package main

import "fmt"

type Fooer[T any] interface {
	Foo(p T)
}

type fooer1[T any] struct{}

func (fooer1[T]) Foo(T) {}

type G[T any] struct{ r []Fooer[T] }

type MyInt int

//go:noinline
func f[T any]() {
	g := G[T]{r: make([]Fooer[T], 1)}
	g.r[0] = fooer1[T]{}
	fmt.Printf("%T\n", g.r[0])
}

func main() {
	f[int]()
	f[MyInt]()
}
