package main

type T struct{}

func (T) m() []int { return []int{1, 2} }

func f(x T) {
	for _, x := range func() []int {
		return x.m() // x is the parameter
	}() {
		_ = x
	}
}

func main() { f(T{}) }
