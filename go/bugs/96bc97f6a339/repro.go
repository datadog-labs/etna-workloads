package main

func f[P any](_ P) {}

func g(x map[func(int)]bool) {
	x[f] = true
}

func h[P map[func(int)]bool](x P) {
	x[f] = true
}

func main() {}
