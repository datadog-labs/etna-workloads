package main

var (
	x = new(0)
	y = x
)

func main() {
	println(*y)
}
