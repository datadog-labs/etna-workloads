package main

type F[T any] func(func(F[T]))

func f(F[int])      {}
func g[T any](F[T]) {}

type MyInt int
type S[T any] []T

func h[T any](S[T]) {}

func main() {
	g(f)
	var x []MyInt
	h(x)
}
