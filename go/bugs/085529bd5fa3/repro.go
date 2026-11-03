package main

import (
	"fmt"
	"unsafe"
)

type Embedded struct {
	B int
}

type S[K any] struct {
	A K
	Embedded
}

func showOffsets[K any](d *S[K]) {
	fmt.Println(unsafe.Offsetof(d.B), unsafe.Offsetof(d.Embedded))
}

func main() {
	showOffsets(new(S[int]))
}
