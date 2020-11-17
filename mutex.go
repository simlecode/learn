package main

import (
	"fmt"
	"sync"
)

func main() {
	var mu sync.Mutex

	mu.Lock()
	fmt.Println("first lock")
	go func() {
		mu.Unlock()
	}()
	mu.Lock()
	fmt.Println("second lock")

	fmt.Println("end")
}

func init() {
	fmt.Println("one")
}

func init() {
	fmt.Println("two")
}
