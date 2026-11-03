package main

var M map[float64]string

func f() int {
	switch M[0.1] != "a" {
	case true:
		return 1
	default:
		return 0
	}
}

func main() {
	println(f())
}
