package main

import "fmt"

func main() {
	var a []any
	var p *any
	var s []*any
	fmt.Printf("%T %T %T\n", a, p, s)
	var x any = a
	var y any = p
	fmt.Println(x == nil, y == nil)
}
