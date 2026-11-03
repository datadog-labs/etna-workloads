package main

import "fmt"

type N[A any] struct{ v A }

func (r N[B]) m[X any](x X, b B) (X, B) {
	if false {
		return r.m(x, b)
	}
	return x, b
}

func (r N[B]) call() {
	fmt.Println(r.m("s", r.v))
	fmt.Println(r.m(1.5, r.v))
	f := r.m[int]
	fmt.Println(f(7, r.v))
}

func main() {
	N[int]{3}.call()
}
