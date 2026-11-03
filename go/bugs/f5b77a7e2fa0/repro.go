package main

import "fmt"

type S struct {
	pre [256]int
	arr [128]int
}

//go:noinline
func smallIntUp(arr *[128]int) {
	for i := int8(0); i <= int8(120); i += int8(10) {
		arr[i] = int(i)
	}
}

func main() {
	defer func() { fmt.Println("recovered:", recover()) }()
	var s S
	smallIntUp(&s.arr)
	n := 0
	for _, v := range s.pre {
		if v != 0 {
			n++
		}
	}
	fmt.Println("out-of-bounds writes:", n)
}
