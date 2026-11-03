package main

import "fmt"

type S struct {
	a [3]int
}

//go:noinline
func a1(i int) {
	var a [2][0]int
	a[i] = [0]int{}
}

//go:noinline
func a2(i int) int {
	var a [0][2]int
	return a[i][0]
}

//go:noinline
func a3(i int) {
	var a [0][2]int
	a[i][0] = 1
}

//go:noinline
func a4(i int) {
	var x [0]S
	x[i].a[1] = 3
}

func try(name string, f func()) {
	defer func() {
		fmt.Println(name, "->", recover())
	}()
	f()
}

func main() {
	try("a1", func() { a1(5) })
	try("a2", func() { _ = a2(5) })
	try("a3", func() { a3(5) })
	try("a4", func() { a4(3) })
}
