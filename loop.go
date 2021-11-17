package main

import "fmt"

func main() {
	loop()
}

func loop()  {
	var l = 1

	fmt.Println("start loop")

breakLoop:
	for ;l < 10; l++ {
		fmt.Println(l)
		if l == 8 {
			break breakLoop
		}
	}
	fmt.Println("end loop")
}
