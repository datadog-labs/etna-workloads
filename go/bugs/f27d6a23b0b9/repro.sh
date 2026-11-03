set -e
mkdir -p a
cat > go.mod <<'X'
module m
go 1.27
X
cat > a/a.go <<'X'
package a

import "unsafe"

func F[T any]() uintptr {
	var t T
	return unsafe.Sizeof(t)
}

func G[T any]() uintptr {
	var t T
	return unsafe.Alignof(t)
}
X
cat > main.go <<'X'
package main

import (
	"fmt"

	"m/a"
)

func main() {
	fmt.Println(a.F[int64](), a.G[int8]())
}
X
"$GO" run -trimpath . 2>&1
echo "exit=$?"
