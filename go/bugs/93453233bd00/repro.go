package main

import "unsafe"

var i = 257

func main() {
	var buf [10]byte
	p0 := unsafe.Pointer(&buf[0])
	p1 := unsafe.Pointer(&buf[1])

	if p := unsafe.Add(p0, uint8(i)); p != p1 {
		println("FAIL: Add with uint8(i) gave wrong pointer")
	}

	var x uint8
	if i != 0 {
		x = 1
	}
	if p := unsafe.Add(p0, x); p != p1 {
		println("FAIL: Add with x gave wrong pointer")
	}
}
