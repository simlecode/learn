package main

import (
	"fmt"
	"reflect"
)

func main()  {
	assignableTo()
}

type structOne struct {}

func (so structOne)String() string {
	return reflect.ValueOf(so).String()
}

type structTwo struct {}

func (st structTwo)String() string {
	return reflect.ValueOf(st).String()
}

func assignableTo()  {
	st := reflect.TypeOf(structOne{})
	fmt.Println(reflect.TypeOf(structOne{}).AssignableTo(reflect.TypeOf(structOne{})))
	fmt.Println(reflect.TypeOf(&structOne{}).AssignableTo(reflect.PtrTo(reflect.TypeOf(structOne{}))))

	fmt.Println(reflect.TypeOf(reflect.New(st).Interface()).AssignableTo(reflect.PtrTo(reflect.TypeOf(structOne{}))))

	fmt.Println(reflect.TypeOf(&structOne{}).AssignableTo(reflect.TypeOf(new(fmt.Stringer))))
	fmt.Println(reflect.TypeOf(&structOne{}).AssignableTo(reflect.TypeOf(&structTwo{})))
}