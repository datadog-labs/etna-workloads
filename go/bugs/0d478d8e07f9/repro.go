package main

type A = uint8
type E uint8

func f[P ~A](P) {}

func main() {
	var e E
	f(e)
	println("ok")
}
