package main

func f[P any](x P) {
	var s []byte
	_ = append(s, x...)
	copy(s, x)
}

func main() {}
