package main

type C2 interface {
	comparable
	[2]any | int
}

func G2[T C2](t T) bool { return t == t }

func main() {
	println(G2[[2]any]([2]any{}))
}
