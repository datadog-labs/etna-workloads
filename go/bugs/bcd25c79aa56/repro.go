package main

type P struct {
	q struct{}
	p *int
}

func f(x any) {
	h(x.(P))
}

//go:noinline
func h(P) {
}

func main() {
	n := 1
	f(P{p: &n})
}
