package main

var m map[int]int

func main() {
	var ok = undef
	x, ok := m[0]
	_ = x
}
