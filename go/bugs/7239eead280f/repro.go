package main

import "unsafe"

type _ A
type A = T
type T [unsafe.Sizeof(A{})]int

func main() {}
