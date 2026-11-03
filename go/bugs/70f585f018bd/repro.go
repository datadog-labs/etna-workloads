package main

type X[T any] interface {
	X[*T]
}

var _ X[int]

func main() {}
