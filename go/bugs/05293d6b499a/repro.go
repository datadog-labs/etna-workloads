package main

func f[P ~*T, T any]() {
	var p P
	var tp *T
	tp = p // valid assignment
	_ = tp
}

func main() {
	f[*int, int]()
	println("ok")
}
