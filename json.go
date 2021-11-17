package main

import (
	"encoding/json"
	"fmt"
)

func main() {
	testJsonMarshal()
}

type S struct {
	a string
	b int
}

func testJsonMarshal() {
	s := S{
		a: "aaa",
		b: 222,
	}
	prefix := "{"
	indent := "  "

	s1, _ := json.Marshal(s)
	fmt.Println("json.Marshal: ", s1)

	s2, _ := json.MarshalIndent(s, prefix, indent)
	fmt.Println("json.MarshalIndent: ", s2)
}
