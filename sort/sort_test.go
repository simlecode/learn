package sort

import (
	"fmt"
	"testing"
	"unsafe"

	. "github.com/smartystreets/goconvey/convey"
)

var arr = []int{1, 3, 2, 4, 4, 5}
var arrSort = []int{5, 4, 4, 3, 2, 1}

func TestBubbleSort(t *testing.T) {
	Convey("test bubble sort", t, func() {
		//a := BubbleSort(arr)
		//fmt.Println(a, reflect.TypeOf(a), reflect.TypeOf(arrSort), arr)
		//So(a, ShouldEqual, arrSort)
		//So([]int{}, ShouldEqual, []int{})
		var i int
		var s []string
		var s1 *string
		s2 := make([]string, 0)
		s3 := new(string)
		fmt.Println(s == nil, s1 == nil, s2 == nil, s3 == nil, &s == nil)
		fmt.Println(unsafe.Sizeof(i), unsafe.Sizeof(s), unsafe.Sizeof(s1), unsafe.Sizeof(s2), unsafe.Sizeof(s3))
		So(s, ShouldBeNil)
		So(s1, ShouldBeNil)

		fmt.Println(insertionSort(arr))
		fmt.Println(shellSort(arr, 6))
		fmt.Println(quickSort(arr, 0, len(arr)-1))
	})
}
