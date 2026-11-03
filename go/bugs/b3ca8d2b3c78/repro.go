package main

import (
	"fmt"
	"math"
)

func main() {
	x := min(0.1, 0.2, math.Sqrt(1))
	y := max(0.1, 0.2, math.Sqrt(0))
	fmt.Println(x, y)
}
