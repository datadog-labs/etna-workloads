mkdir -p a
cat > go.mod <<'X'
module m
go 1.20
X
cat > a/a.go <<'X'
package a

import "math/rand"

type Integer interface {
	~int | ~int8 | ~int16 | ~int32 | ~int64 |
		~uint | ~uint8 | ~uint16 | ~uint32 | ~uint64 | ~uintptr
}

type Builder[T Integer] struct{}

func (r Builder[T]) New() T {
	return T(rand.Int())
}

var IntBuilder = Builder[int]{}

func BuildInt() int {
	return IntBuilder.New()
}
X
cat > main.go <<'X'
package main

import "m/a"

//go:noinline
func BuildInt() int {
	return a.BuildInt()
}

func main() {
	BuildInt()
	println("ok")
}
X
"$GO" run -trimpath . 2>&1
echo "exit $?"
