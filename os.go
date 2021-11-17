package main

import (
	"fmt"
	"os"
)

func main()  {
	create()
}

func create()  {
	err := os.Mkdir("./aaa", 0755)
	fmt.Println(err)
}
