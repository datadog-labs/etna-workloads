package main

type X struct{}

func (x X) M() int { return 42 }

func CallM2[T interface {
	X
	M() R
}, R any](t T) R {
	return t.M()
}

func main() {
	println(CallM2(X{}))
}
