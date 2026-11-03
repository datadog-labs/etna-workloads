package main

import "fmt"

func main() {
	m := map[int]int{}
	var p *int
	func() {
		defer func() { recover() }()
		m[2], *p = 42, 2
	}()
	fmt.Println(len(m), m[2])

	m2 := map[int]int{}
	s := []int{}
	func() {
		defer func() { recover() }()
		m2[2], s[1] = 2, 2
	}()
	fmt.Println(len(m2), m2[2])
}
