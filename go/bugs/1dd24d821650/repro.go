package main

type T1[P any] interface{ m() }

func g[P any](T1[P]) {}

func main() {
	var x T1[int]
	g(x)
}
