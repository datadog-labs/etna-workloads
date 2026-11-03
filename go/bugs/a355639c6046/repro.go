package main

type T struct{ x int }

//go:noinline
func f(p **T, q *T, sp *string, r *uint64) {
	*p = q
	*r = uint64(len(*sp)) / 7
}

func main() {
	var t *T
	var n uint64
	s := "hello world, this is a string"
	f(&t, &T{}, &s, &n)
	println(n)
}
