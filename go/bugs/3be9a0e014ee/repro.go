package main

type S struct{}

func (S) G() {}

func main() {
	var s S
	_ = must(s.F())
}

func must[T any](x T, err error) T {
	if err != nil {
		panic(err)
	}
	return x
}
