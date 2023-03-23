package main

import "fmt"

func testChannel() {
	testSelect()
	//testChannel()
}

func testChannel2() {
	// 无缓冲channel连续写或者读会死锁
	ch := make(chan int)
	ch <- 1
	ch <- 2
	fmt.Println(<-ch)
}

func testSelect() {
	fmt.Println("select start")
	ch := make(chan int)
	select { // 无符合条件会死锁
	case <-ch:
		fmt.Println("select ch")
	default:
		fmt.Println("select default")
	}
	fmt.Println("select end")
}
