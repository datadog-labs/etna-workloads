package main

import "unsafe"

type a struct {
	_ [42 - unsafe.Sizeof(a{})]byte
}

func main() {}
