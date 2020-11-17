package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	fmt.Println(shuffle(10))
	rand.Seed(time.Now().Unix())
}

func shuffle(n int) []int {
	return rand.Perm(n)
}
