package main

func f[P interface{ m(R) }, R any]() {}

type T = interface{ m(int) }

func main() {
	_ = f[T]
	println("ok")
}
