package main

const c1 = iota
const c2 = iota

const c3 = 0 + iota<<8
const c4 = 1 + iota<<8

func main() {
	const c5 = iota
	const c6 = iota
	println(c1, c2, c3, c4, c5, c6)
}
