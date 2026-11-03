package main

type A = interface{}
type B interface{}

type C interface {
	A
	B
}

func main() {
	var c C
	println(c == nil)
}
