package main

import "unsafe"

type T1[T any] [42]T2[T]

type T2[T any] [42]T

func f[T any]() uintptr {
	return unsafe.Sizeof(T1[T]{})
}

func main() {
	println(f[int32]())
}
