package main

import "math"

func main() {
	f()
	g()
	h()
}

func f() {
	n := 0
	for i := int64(math.MaxInt64); i <= math.MaxInt64; i++ {
		if i < 0 {
			println("done")
			return
		}
		println(i, i < 0)
		if n++; n > 3 {
			println("runaway")
			return
		}
	}
}

func g() {
	n := 0
	for i := int64(math.MaxInt64) - 1; i <= math.MaxInt64; i++ {
		if i < 0 {
			println("done")
			return
		}
		println(i, i < 0)
		if n++; n > 3 {
			println("runaway")
			return
		}
	}
}

func h() {
	n := 0
	for i := int64(math.MaxInt64) - 2; i <= math.MaxInt64; i += 2 {
		if i < 0 {
			println("done")
			return
		}
		println(i, i < 0)
		if n++; n > 3 {
			println("runaway")
			return
		}
	}
}
