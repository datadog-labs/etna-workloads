package main

//go:noinline
func use(b bool) {}

func f(x bool) bool {
	if x || true {
		return true
	}
	return true
}

func g(x bool) bool {
	if x || true {
		return true
	} else {
		return true
	}
}

func main() {
	if f(false) {
		println("f ok")
	}
	if g(false) {
		println("g ok")
	}
}
