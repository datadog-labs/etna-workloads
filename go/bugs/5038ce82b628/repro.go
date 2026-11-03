package main

var x = 0
var a = foo()
var b = x

func foo() int {
	x++
	return x
}

func main() {
	println("a =", a, "b =", b)
}
