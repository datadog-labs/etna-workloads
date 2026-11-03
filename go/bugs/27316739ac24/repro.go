package main

import (
	"fmt"
	"unsafe"
)

func sliceData[E any, S ~[]E](s S) *E {
	return unsafe.SliceData(s)
}

func slice[E any, S ~*E](s S) []E {
	return unsafe.Slice(s, 1)
}

func main() {
	s := []uint32{7}
	fmt.Println(*sliceData(s), slice(&s[0]))
}
