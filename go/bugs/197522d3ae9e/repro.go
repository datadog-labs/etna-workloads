package main

type Interface[T any] interface {
	m(Interface[T])
}

func f[S []Interface[T], T any](S) {}

func main() {
	var s []Interface[int]
	f(s)
	println("ok")
}
