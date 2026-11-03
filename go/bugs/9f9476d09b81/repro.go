package main

import "math/bits"

//go:noinline
func add(p, q, x, y uint64) uint64 {
	c := uint64(0)
	if p < q {
		c = 1
	}
	s, _ := bits.Add64(x, y, c)
	return s
}

//go:noinline
func sub(p, q, x, y uint64) uint64 {
	c := uint64(0)
	if p < q {
		c = 1
	}
	s, _ := bits.Sub64(x, y, c)
	return s
}

func main() {
	println(add(1, 2, 10, 20), add(2, 1, 10, 20))
	println(sub(1, 2, 10, 20), sub(2, 1, 10, 20))
}
