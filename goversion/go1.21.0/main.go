package main

import (
	"cmp"
	"fmt"
	"log"
	"maps"
	"math"
	"slices"
	"sync"
)

func main() {
	numbers := []int{3, 2}
	m := map[string]struct{}{
		"str": {},
		"3":   {},
	}

	// math.Max and math.Min
	max, min := compare(float64(numbers[0]), float64(numbers[1]))
	if max != float64(numbers[0]) || min != float64(numbers[1]) {
		log.Fatalf("compare not match, %v != %v, %v != %v", max, numbers[0], min, numbers[1])
	}

	// clear
	clear(numbers)
	clear(m)
	fmt.Println(numbers, m)
	if numbers[0] != 0 || numbers[1] != 0 || len(m) != 0 {
		log.Fatalf("clear failed: %v ,%v", numbers, len(m))
	}

	var wg sync.WaitGroup
	for _, v := range []int{1, 2, 3, 4} {
		wg.Add(1)
		go func() {
			defer wg.Done()

			fmt.Println("i:", v)
		}()
	}
	wg.Wait()

	useSlices()
	useMaps()
	useCmp()
}

func compare(num, num2 float64) (float64, float64) {
	return math.Max(num, num2), math.Min(num, num2)
}

func useSlices() {
	numbers := []int{3, 2, 5, 10}

	slices.Sort(numbers)

	fmt.Println("after sort:", numbers)
}

func useMaps() {
	m := map[string]struct{}{
		"1": {},
		"3": {},
	}

	m2 := maps.Clone[map[string]struct{}](m)

	fmt.Println(maps.Equal[map[string]struct{}](m, m2))
}

func useCmp() {
	fmt.Println("cmp:", cmp.Compare[int](1, 4))
}
