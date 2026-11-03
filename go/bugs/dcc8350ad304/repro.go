package main

import "fmt"

type Numeric interface {
	int32 | int64 | float64 | complex64
}

//go:noinline
func inc[T Numeric](x T) T {
	x++
	return x
}

func main() {
	fmt.Println(inc(int32(5)), inc(int64(5)), inc(float64(5)), inc(complex64(5)))
}
