package main

type C[E any] interface {
	m(<-chan E)
}

type S struct{}

func (S) m(chan int) {}

func f[T C[E], E any](T) {}

func main() {
	f(S{})
}
