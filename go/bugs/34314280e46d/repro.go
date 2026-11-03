package main

const (
	_ = int(complex64(int(0)))
	_ = float64(complex128(float64(0)))
)

func main() {
	println(int(complex64(int(3))), float64(complex128(float64(2))))
}
