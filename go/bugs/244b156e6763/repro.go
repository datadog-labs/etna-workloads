package main

type S struct {
	a [4]struct{}
	f chan int
}

//go:noinline
func f(p *S) {
	var s S
	*p = s
}

func main() {
	p := &S{f: make(chan int)}
	f(p)
	println(p.f == nil)
}
