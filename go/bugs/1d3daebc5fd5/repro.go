package main

type I[T any] interface {
	m(T)
}

func f5[T any](I[T]) {}

func main() {
	var x interface {
		m(int)
		n()
	}
	f5(x)
	println("ok")
}
