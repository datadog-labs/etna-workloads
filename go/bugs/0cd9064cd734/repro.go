package main

type S[T any] struct{}

func (S[T]) m(T) {}

func f0[T any](chan S[T]) {}

func main() {
	var x chan interface{ m(int) }
	f0(x)
}
