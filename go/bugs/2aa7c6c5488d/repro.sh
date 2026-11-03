cat > x.go <<'EOT'
package main

import "math"

//go:noinline
func nan64() float64 {
	zero := 0.0
	inf := 1 / zero
	negone := -1.0
	z0 := zero / zero
	z1 := zero * inf
	z2 := math.Sqrt(negone)
	return z0 + z1 + z2
}

func main() { println(nan64() == nan64()) }
EOT
export GOCACHE="$PWD/gocache"
"$GO" build -trimpath -gcflags=-S -o /dev/null x.go 2>&1 | grep -E 'DIVSD|MULSD|SQRTSD' | sed 's/^[^)]*) *//'
