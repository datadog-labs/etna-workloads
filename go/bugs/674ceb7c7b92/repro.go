package main

func f[P []byte](p string) {
	_ = (*P)(p)
}

func main() {}
