package main

func main() {}

func _() { g() }

func g[T any]() (_, int) { panic(0) }

var _ = append(f()())

func f[T any]() (_, _, int) {
	panic("not implemented")
}
