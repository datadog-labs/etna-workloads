package main

type nat []int

var a, b nat = y()

func y() (nat, []int) {
	return nat{0}, nat{1}
}

func main() {
	println(a[0], b[0])
}
