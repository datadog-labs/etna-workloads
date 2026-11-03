package main

type B1 interface {
	_()
	M()
}

type T2 struct{}

func (t *T2) M() {}
func (t *T2) _() {}

var b1 B1 = &T2{}

func main() {}
