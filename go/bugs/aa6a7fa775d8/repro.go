package main

import "reflect"

func one() any { type T[_ any] int; return T[int](0) }
func two() any { type T[_ any] int; return T[int](0) }

func main() {
	p, q := one(), two()
	println(p == q)
	for _, x := range []any{p, q} {
		println(reflect.TypeOf(x).String())
	}
}
