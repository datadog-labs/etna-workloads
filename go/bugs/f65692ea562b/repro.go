package main

type T struct {
	a [192]byte
}

func f(x *T) {
	i := any(x)
	y := i.(*T)
	*y = *x
}

func main() {
	var t T
	f(&t)
}
