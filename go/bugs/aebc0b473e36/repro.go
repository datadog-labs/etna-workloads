package main

var n int

func g() bool {
	n++
	return n == 1
}

func f(y int) bool {
	b, ok := true, false
	if y > 1 {
		ok = g()
	}
	if !ok {
		ok = g()
		b = false
	}
	if !ok {
		return false
	}
	return b
}

func main() {
	println(f(2), f(0))
}
