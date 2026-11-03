package main

var _ = func() int {
	a = false
	return 0
}()

var a = true
var b = a

func main() {
	println("b =", b)
}
