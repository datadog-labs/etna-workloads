package main

import "fmt"

const arrFooSize = 96

type arrFoo [arrFooSize]int

//go:noinline
func badCopy(dst, src []int) {
	p := (*[arrFooSize]int)(dst[:arrFooSize])
	q := (*[arrFooSize]int)(src[:arrFooSize])
	*p = arrFoo(*q)
}

//go:noinline
func goodCopy(dst, src []int) {
	p := (*[arrFooSize]int)(dst[:arrFooSize])
	q := (*[arrFooSize]int)(src[:arrFooSize])
	*p = *q
}

func main() {
	h1 := make([]int, arrFooSize+1)
	h2 := make([]int, arrFooSize+1)
	for i := range arrFooSize + 1 {
		h1[i] = i
		h2[i] = i
	}
	badCopy(h1[1:], h1[:arrFooSize])
	goodCopy(h2[1:], h2[:arrFooSize])
	for i := range arrFooSize + 1 {
		if h1[i] != h2[i] {
			fmt.Printf("differ at index %d: %d vs %d\n", i, h1[i], h2[i])
			return
		}
	}
	fmt.Println("same")
}
