package main

import "runtime"

//go:noinline
func f(v int) int {
	var x int
	x = v
	a := [...][]*int{
		{&x},
		nil,
		nil,
		nil,
		nil,
	}
	grow(200)
	runtime.GC()
	*a[0][0] += 1
	return x
}

//go:noinline
func grow(n int) byte {
	var buf [1024]byte
	if n == 0 {
		return buf[0]
	}
	return grow(n-1) + buf[n%1024]
}

func main() {
	for i := 0; i < 3; i++ {
		println(f(i))
	}
	// second call sees stale pointer if static array kept first call's &x
	b := f(10)
	println(b)
}
