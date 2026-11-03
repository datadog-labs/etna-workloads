package main

type T struct {
	a, b, c, d struct{}
	e          *byte
}

func f1(p *any, t T) {
	*p = t
}

func f2(p *any, t *T) {
	*p = *t
}

func f3(p, x, y *T, b bool) {
	var z T
	if b {
		z = *x
	} else {
		z = *y
	}
	*p = z
}

func f4(i any) T {
	return i.(T)
}

func main() {
	var a any
	x := new(byte)
	f1(&a, T{e: x})
	println(f4(a).e == x)
}
