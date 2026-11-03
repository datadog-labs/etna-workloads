package main

type T struct{ a, b int }

func main() {
	_ = T{1, b: 2}
	_ = T{a: 1, 2}
	_ = []int{1 + 2: 3, "x": 4}
	_ = [2]int{0: 1, 1 + 0: 2, 5: 3}
	_ = struct{ a int }{a: 1, a: 2}
}
