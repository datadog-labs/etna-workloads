package main

type S1 struct {
	x int "S1.x"
}

type S2 struct {
	x int "S2.x"
}

func f[P1 S1, P2 S2]() {
	type A = P1
	var p A
	_ = P2(p) // conversion must be valid
}

func g() {
	type (
		S struct{}
		A = *S
		T S
	)
	var p A
	_ = (*T)(p)
}

func main() {
	f[S1, S2]()
	g()
	println("ok")
}
