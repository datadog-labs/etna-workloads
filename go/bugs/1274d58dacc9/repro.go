package main

import "unsafe"

type A [unsafe.Sizeof(B{})]int
type B A

func main() {
	println(len(A{}))
}
