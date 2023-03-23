package main

import (
	"errors"
	"fmt"
	"time"
)

func main() {
	// fmt.Println(Foo())
	defer func() {
		// recover只能recover同一个协程内的panic
		// recover相当于栈，先进后出
		if err := recover(); err != nil {
			fmt.Println(err)
		}
	}()

	//go a()
	a()

	time.Sleep(time.Second)
	//recoverCall()
}

func a() {
	//defer func() {
	//	if err := recover(); err != nil {
	//		fmt.Println(err)
	//	}
	//}()
	panic("a")
}

type st struct {
}

func recoverCall() {
	defer func() { fmt.Println("1") }()
	defer func() { fmt.Println("2") }()
	defer func() { fmt.Println("3") }()
	panic("")
}

// 在局部作用域中，命名的返回值内同名的局部变量屏蔽：
func Foo() (err error) {
	if err = bar(); err != nil {
		return
	}
	return
}

func bar() error {
	return errors.New("error")
}
