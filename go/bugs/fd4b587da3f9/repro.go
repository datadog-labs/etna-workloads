package main

func f(a int, b ...int) {}

func main() {
	f(nil...)
}
