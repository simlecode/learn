package sort

//冒泡排序
func bubbleSort(arr []int) []int {
	len := len(arr)
	for i := 0; i < len-1; i++ {
		for j := i + 1; j < len; j++ {
			if arr[i] < arr[j] {
				arr[i], arr[j] = arr[j], arr[i]
			}
		}
	}

	return arr
}

//插入排序
func insertionSort(arr []int) []int {
	len := len(arr)
	j, temp := 0, 0
	for i := 1; i < len; i++ {
		temp = arr[i]
		for j = i; j > 0 && arr[j-1] < temp; j-- {
			arr[j] = arr[j-1]
		}
		arr[j] = temp
	}

	return arr
}

//希尔排序
func shellSort(arr []int, n int) []int {
	temp, j := 0, 0
	for gap := n / 2; gap > 0; gap /= 2 {
		for i := gap; i < n; i++ {
			temp = arr[i]
			j = i
			for j := i; j > gap && arr[j-gap] < temp; j -= gap {
				arr[j] = arr[j-gap]
			}
		}
		arr[j] = temp
	}

	return arr
}

//快速排序
func quickSort(arr []int, low, high int) []int {
	//low, high := 0, len(arr)
	mid := high
	if low < high-1 {
		mid = partition(arr, low, high)
		quickSort(arr, low, mid-1)
		quickSort(arr, mid+1, high)
	}

	return arr
}

func partition(arr []int, low, high int) int {
	pivot := arr[high]
	i := low - 1
	for j := 0; j < high; j++ {
		if arr[j] < pivot {
			i++
			arr[j], arr[i] = arr[i], arr[j]
		}
	}
	arr[i+1], arr[high] = arr[i+1], arr[high]

	return i + 1
}
