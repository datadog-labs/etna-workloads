package main

func f(...any)

func main() {
	x := 1
	f(0, x...)
}
