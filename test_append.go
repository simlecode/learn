package main

import "fmt"

func testAppend() {
	//a := make([]int,0, 3)
	//a = append(a, 1,2)
	//fmt.Printf("a len=%d, cap=%d\n", len(a), cap(a))
	//
	//b := append(a, 3) // a 和 b 用的是同一块内存地址
	//fmt.Printf("a: %v, b: %v, a addr: %p, b addr: %p\n", a, b, &a, &b)
	//
	//a = append(a, 4)
	//fmt.Printf("a: %v, b: %v, a addr: %p, b addr: %p\n", a, b, &a, &b)
	//
	//
	//c := append(a, 6) // 切片超出容量3，进行扩容，返回新的地址
	//fmt.Printf("a: %v, c: %v, a addr: %p, c addr: %p\n", a, c, &a, &c)
	//
	//a = append(a, 5) // 切片超出容量3，进行扩容，返回新的地址，所以没有改变 c 下标是3（6）的值
	//fmt.Printf("a len=%d, cap=%d\n", len(a), cap(a))
	//fmt.Printf("a: %v, b: %v, c:%v, a addr: %p, b addr: %p\n", a, b, c, &a, &b)

	var arr = []int{1, 2, 3, 4}
	d := arr[:2]
	fmt.Println(arr, d, len(d), cap(d))
	d[0] = 0
	fmt.Println(arr, d, len(d), cap(d))
	d = append(d, []int{3, 4, 5}...)
	fmt.Println(arr, d, len(d), cap(d))
	d[0] = 1
	fmt.Println(arr, d, len(d), cap(d))
}
