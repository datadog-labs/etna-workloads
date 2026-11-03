package main

type T0[P any] struct {
	f P
}

type T1 struct {
	_ T0[T1]
}

type A[P any] [10]P

type X A[X]

func main() {}
