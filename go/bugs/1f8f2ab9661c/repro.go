package main

func f[T any](...T) T { var x T; return x }

func main() {
	var a chan string
	var b <-chan string
	f(a, b)
	f(b, a)
	println("ok")
}
