package main

func g[T any](T) {}

func f[F func(int)]() {
	_ = struct{ f F }{f: g}
	_ = [42]F{g}
	_ = []F{g}
	_ = map[int]F{42: g}
	_ = F(g)
	make(chan F, 1) <- g
}

func main() {
	type F func(int)
	_ = struct{ f F }{f: g}
	_ = F(g)
	f[func(int)]()
	println("ok")
}
