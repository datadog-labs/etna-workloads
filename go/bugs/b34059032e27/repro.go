package main

func f[S any](S) {}

var s struct{ x int }

func main() {
	f(s.y)
	f(1 / s)
}
