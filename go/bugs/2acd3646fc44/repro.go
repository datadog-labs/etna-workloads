package main

import "math"

func main() {
	j(math.MinInt64)
}

//go:noinline
func j(i int64) {
	n := 0
	for j := int64(math.MaxInt64); j <= i-1; j++ {
		if j < 0 {
			println("wrapped")
			return
		}
		println(j)
		n++
		if n > 3 {
			println("runaway loop")
			return
		}
	}
}
