package main

func f(func(int), func(string)) {}

func g[P any](x P) { println(x) }

func main() {
	f(g, g)
}
