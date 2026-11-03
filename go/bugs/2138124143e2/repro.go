package main

func f[P int | float64 | complex128]() {
	_ = map[P]int{1: 1, 1.0: 2, 1 + 0i: 3}
}

func main() {
	f[int]()
}
