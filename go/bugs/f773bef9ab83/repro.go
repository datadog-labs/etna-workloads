package main

type FreeListG[T any] struct {
	freelist []*node[T]
}

type node[T any] struct{}

func NewFreeListG[T any](size int) *FreeListG[T] {
	return &FreeListG[T]{freelist: make([]*node[T], 0, size)}
}

var bf = NewFreeListG[*int](1024)

func main() { println(cap(bf.freelist)) }
