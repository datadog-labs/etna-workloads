package main

import "fmt"

type G[P any] struct{}

func (g *G[P]) m[Q any]() {
	var p P
	var q Q
	if got := fmt.Sprintf("%T %T", p, q); got != "int bool" {
		panic(fmt.Sprintf("got %s, want int bool", got))
	}
	fmt.Println("ok")
}

func main() {
	(&G[int]{}).m[bool]()
}
