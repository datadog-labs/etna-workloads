package main

type zeroSizeSpecial struct {
	_ [0]float64
}

var x [3]zeroSizeSpecial

func f() bool {
	return x == x
}

func main() {
	println(f())
}
