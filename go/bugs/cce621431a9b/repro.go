package main

func f(b []byte) []byte {
	return (*[32]byte)(b[:32])[:]
}

func main() {
	b := make([]byte, 40)
	println(len(f(b)))
}
