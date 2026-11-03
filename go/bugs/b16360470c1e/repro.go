package main

type S struct {
	n int
	a [2]int
}

func f(i int) int {
	var arr [0]S
	return arr[i].n
}

func main() {
	defer func() { println("recovered:", recover() != nil) }()
	f(0)
}
