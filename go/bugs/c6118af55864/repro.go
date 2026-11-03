package main

//go:noinline
func add64(x float64) float64 { return x + 0 }

//go:noinline
func add32(x float32) float32 { return x + 0 }

func main() {
	var z64 float64
	var z32 float32
	nz64 := -1 / (1.0 / z64)
	nz32 := -1 / (1.0 / z32)
	println(1/add64(nz64), 1/add32(nz32))
}
