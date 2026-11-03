package main

type M[T any] interface {
	m() T
}

func f[T any](x interface{ m() T }) T { return x.m() }
func g[T any](x M[T]) T               { return x.m() }

type S struct{}

var _ = f(S{})
var _ = g(S{})

func main() {
	var s S
	println(f(s), g(s))
}

func (S) m() int { return 0 }
