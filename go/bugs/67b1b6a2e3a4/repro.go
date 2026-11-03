package main

import "fmt"

//go:noinline
func side() int { fmt.Println("side effect"); return 1 }

//go:noinline
func g(p *[2]int, x int) {}

func main() {
	s := make([]int, 1)
	g((*[2]int)(s), side())
}
