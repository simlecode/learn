package main

import (
	"fmt"
	"os"
)

func create() {
	err := os.Mkdir("./aaa", 0755)
	fmt.Println(err)
}
