package main

type T [1 << 31]byte

func F(m map[int]T) {
	_ = m[0]
}

func main() {}
