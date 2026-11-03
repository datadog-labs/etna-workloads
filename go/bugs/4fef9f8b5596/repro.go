package main

func main() {
	type (
		A = int
		B = []A
	)
	var b B = []int{1}
	println(len(b))
}
