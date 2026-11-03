package main

import "fmt"

func main() {
	defer func() {
		fmt.Println(recover())
	}()
	foo(7, 8, []uint64{0})
}

//go:noinline
func foo(a, b int, haystack []uint64) uint64 {
	s := uint64(a * b)
	for n := range len(haystack) {
		_ = n
		s += haystack[1]
	}
	return s + uint64(len(haystack[0:len(haystack)]))
}
