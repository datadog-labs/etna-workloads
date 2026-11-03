package main

type T1 int
type T2 int

func f[P T1 | T2, _ []P]() {}

var _ = f[T1]

func g3[T any](*T, ...T) {}

func main() {
	type myString string
	var s1 string
	g3(&s1, "1", myString("2"), "3")
	println("ok")
}
