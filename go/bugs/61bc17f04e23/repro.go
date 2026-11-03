package main

import "unsafe"

//go:noinline
func f(x []byte) bool {
	return unsafe.SliceData(x) != nil
}

func main() {
	println(f(nil))
}
