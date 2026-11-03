package main

func f[P any](x P) P { return x }

func main() {
	type A = int
	var a A
	b := f(a)
	_ = b + "foo"
}
