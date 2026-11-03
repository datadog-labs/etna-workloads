package main

type G[T any] struct {
	h H[G[T]]
}

type H[T any] struct{}

var x G[int]

func main() {
	println(len(x.h.String()))
}

func (H[T]) String() string { return "ok" }
