package main

import (
	"context"
	"fmt"
	"go.opentelemetry.io/collector/component"
	"go.opentelemetry.io/collector/config/confighttp"
	semconv "go.opentelemetry.io/otel/semconv/v1.4.0"
	"go.opentelemetry.io/otel/trace"

	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/baggage"
	"go.opentelemetry.io/otel/exporters/otlp"
	_ "go.opentelemetry.io/otel/exporters/otlp/otlpgrpc"
	"go.opentelemetry.io/otel/exporters/otlp/otlphttp"
	"go.opentelemetry.io/otel/metric"
	"go.opentelemetry.io/otel/metric/global"
	"go.opentelemetry.io/otel/propagation"
	controller "go.opentelemetry.io/otel/sdk/metric/controller/basic"
	processor "go.opentelemetry.io/otel/sdk/metric/processor/basic"
	"go.opentelemetry.io/otel/sdk/metric/selector/simple"
	"go.opentelemetry.io/otel/sdk/resource"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	_ "google.golang.org/grpc"

	"go.opentelemetry.io/collector/component/componenttest"
	"go.opentelemetry.io/collector/config/configgrpc"
	"go.opentelemetry.io/collector/config/confignet"
	"go.opentelemetry.io/collector/receiver/jaegerreceiver"
	"go.uber.org/zap"
)

func jaeger() error {
	endPoint := "localhost:1245"
	factory := jaegerreceiver.NewFactory()
	cfg := factory.CreateDefaultConfig().(*jaegerreceiver.Config)
	cfg.Protocols.GRPC = &configgrpc.GRPCServerSettings{
		NetAddr: confignet.NetAddr{Endpoint: endPoint, Transport: "tcp"},
	}
	cfg.Protocols.ThriftHTTP = &confighttp.HTTPServerSettings{
		Endpoint: endPoint,
	}
	var err error
	set := component.ReceiverCreateSettings{
		Logger:         zap.NewNop(),
		TracerProvider: trace.NewNoopTracerProvider(),
		BuildInfo:      component.DefaultBuildInfo(),
	}
	//tc, err := consumerhelper.NewTraces(func(ctx context.Context, ld pdata.Traces) error {
	//	return nil
	//})
	//if err != nil {
	//	log.Fatal(err)
	//}
	receiver, err := factory.CreateTracesReceiver(context.Background(), set, cfg, nil)
	if err != nil {
		return err
	}

	return receiver.Start(context.Background(), componenttest.NewNopHost())
}

func test()  {
	//addr := "127.0.0.1:4317"
	s := http.DefaultServeMux
	s.HandleFunc("/v1/metrics", func(writer http.ResponseWriter, request *http.Request) {
		b, err := ioutil.ReadAll(request.Body)
		if err != nil {
			fmt.Println("metrics err ", err)
		}
		fmt.Println("metrics ", string(b))
	})
	s.HandleFunc("/v1/traces", func(writer http.ResponseWriter, request *http.Request) {
		b, err := ioutil.ReadAll(request.Body)
		if err != nil {
			fmt.Println("traces err ", err)
		}
		fmt.Println("traces ", string(b))
	})
	fmt.Println("start server")
	err := http.ListenAndServe(":4317", s)
	if err != nil {
		panic(err)
	}
}

// Initializes an OTLP exporter, and configures the corresponding trace and
// metric providers.
func initProvider() func() {
	go func() {
		test()
	}()

	ctx := context.Background()

	otelAgentAddr, ok := os.LookupEnv("OTEL_AGENT_ENDPOINT")
	if !ok {
		//otelAgentAddr = "0.0.0.0:4317"
		otelAgentAddr = "127.0.0.1:4317"
	}

	//exp, err := otlp.NewExporter(ctx, otlpgrpc.NewDriver(
	//	otlpgrpc.WithInsecure(),
	//	otlpgrpc.WithEndpoint(otelAgentAddr),
	//	otlpgrpc.WithDialOption(grpc.WithBlock()), // useful for testing
	//))

	exp, err := otlp.NewExporter(ctx, otlphttp.NewDriver(
		otlphttp.WithEndpoint(otelAgentAddr), // useful for testing
		otlphttp.WithInsecure(),
		//otlphttp.WithTracesURLPath("http://127.0.0.1:4317"),
	))
	handleErr(err, "failed to create exporter")

	res, err := resource.New(ctx,
		resource.WithAttributes(
			// the service name used to display traces in backends
			semconv.ServiceNameKey.String("test-service"),
		),
	)
	handleErr(err, "failed to create resource")

	bsp := sdktrace.NewBatchSpanProcessor(exp)
	tracerProvider := sdktrace.NewTracerProvider(
		sdktrace.WithSampler(sdktrace.AlwaysSample()),
		sdktrace.WithResource(res),
		sdktrace.WithSpanProcessor(bsp),
	)

	cont := controller.New(
		processor.New(
			simple.NewWithExactDistribution(),
			exp,
		),
		controller.WithCollectPeriod(7*time.Second),
		controller.WithExporter(exp),
	)

	// set global propagator to tracecontext (the default is no-op).
	otel.SetTextMapPropagator(propagation.TraceContext{})
	otel.SetTracerProvider(tracerProvider)
	global.SetMeterProvider(cont.MeterProvider())
	handleErr(cont.Start(context.Background()), "failed to start metric controller")

	return func() {
		handleErr(tracerProvider.Shutdown(ctx), "failed to shutdown provider")
		handleErr(cont.Stop(context.Background()), "failed to stop metrics controller") // pushes any last exports to the receiver
		handleErr(exp.Shutdown(ctx), "failed to stop exporter")
	}
}

func handleErr(err error, message string) {
	if err != nil {
		log.Fatalf("%s: %v", message, err)
	}
}

func main() {
	shutdown := initProvider()
	defer shutdown()

	tracer := otel.Tracer("test-tracer")
	meter := global.Meter("test-meter")

	// labels represent additional key-value descriptors that can be bound to a
	// metric observer or recorder.
	// TODO: Use baggage when supported to extact labels from baggage.
	commonLabels := []attribute.KeyValue{
		attribute.String("method", "repl"),
		attribute.String("client", "cli"),
	}

	// Recorder metric example
	requestLatency := metric.Must(meter).
		NewFloat64ValueRecorder(
			"appdemo/request_latency",
			metric.WithDescription("The latency of requests processed"),
		).Bind(commonLabels...)
	defer requestLatency.Unbind()

	// TODO: Use a view to just count number of measurements for requestLatency when available.
	requestCount := metric.Must(meter).
		NewInt64Counter(
			"appdemo/request_counts",
			metric.WithDescription("The number of requests processed"),
		).Bind(commonLabels...)
	defer requestCount.Unbind()

	lineLengths := metric.Must(meter).
		NewInt64ValueRecorder(
			"appdemo/line_lengths",
			metric.WithDescription("The lengths of the various lines in"),
		).Bind(commonLabels...)
	defer lineLengths.Unbind()

	// TODO: Use a view to just count number of measurements for lineLengths when available.
	lineCounts := metric.Must(meter).
		NewInt64Counter(
			"appdemo/line_counts",
			metric.WithDescription("The counts of the lines in"),
		).Bind(commonLabels...)
	defer lineCounts.Unbind()

	baggage.New()
	defaultCtx := baggage.ContextWithBaggage(context.Background(), commonLabels...)
	rng := rand.New(rand.NewSource(time.Now().UnixNano()))
	for {
		startTime := time.Now()
		ctx, span := tracer.Start(defaultCtx, "ExecuteRequest")
		var sleep int64
		switch modulus := time.Now().Unix() % 5; modulus {
		case 0:
			sleep = rng.Int63n(17001)
		case 1:
			sleep = rng.Int63n(8007)
		case 2:
			sleep = rng.Int63n(917)
		case 3:
			sleep = rng.Int63n(87)
		case 4:
			sleep = rng.Int63n(1173)
		}

		time.Sleep(time.Duration(sleep) * time.Millisecond)

		span.End()
		latencyMs := float64(time.Since(startTime)) / 1e6
		nr := int(rng.Int31n(7))
		for i := 0; i < nr; i++ {
			randLineLength := rng.Int63n(999)
			lineLengths.Record(ctx, randLineLength)
			lineCounts.Add(ctx, 1)
			fmt.Printf("#%d: LineLength: %dBy\n", i, randLineLength)
		}

		requestLatency.Record(ctx, latencyMs)
		requestCount.Add(ctx, 1)
		fmt.Printf("Latency: %.3fms\n", latencyMs)
	}
}
