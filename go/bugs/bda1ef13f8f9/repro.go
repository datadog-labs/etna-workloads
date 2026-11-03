package main

import "fmt"

type T16 struct{ a, b uint16 }

//go:noinline
func (t *T16) store(x uint32) {
	t.a = uint16(x)
	t.b = uint16(x >> 8)
}

func main() {
	t := &T16{}
	t.store(0x11223344)
	fmt.Printf("%x %x\n", t.a, t.b)
}
