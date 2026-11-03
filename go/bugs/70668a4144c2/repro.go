package main

import "unsafe"

type T[P any] struct {
	T[P]
}

func f[P any]() {
	_ = unsafe.Sizeof(T[int]{})
	_ = unsafe.Sizeof(struct{ T[int] }{})
	_ = unsafe.Sizeof(T[P]{})
	_ = unsafe.Sizeof(struct{ T[P] }{})
}

const _ = unsafe.Sizeof(T[int]{})

func main() {}
