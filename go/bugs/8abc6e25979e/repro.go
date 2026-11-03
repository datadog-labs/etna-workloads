package main

func main() {
	s := uint(3)
	var f float64 = min(1 << s)
	println(f)
	var g = min(1 << s)
	println(g)
}
