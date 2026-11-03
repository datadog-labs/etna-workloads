package main

type Tb[P ~*Q, Q any] int

func main() {
	var x Tb[*int]
	println(x)
}
