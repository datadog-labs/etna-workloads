package main

import "fmt"

type F func()

func f[T any](a, b func(T)) {}

func g[T any](x, y T) T { return x }

type S string

func main() {
	var i func(F)
	var j func(F)
	f(i, j)

	var s string
	var m S = "x"
	fmt.Printf("%T\n", g(s, m))
	fmt.Printf("%T\n", g(m, s))
}
