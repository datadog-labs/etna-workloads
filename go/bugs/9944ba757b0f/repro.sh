set -e
mkdir -p a
cat > go.mod <<'X'
module test
go 1.21
X
cat > a/a.go <<'X'
package a

func F() {
	g(0)
}

func g[T any](_ T) {}
X
cat > main.go <<'X'
package main

import "test/a"

func main() {
	a.F()
}
X
"$GO" build -trimpath -gcflags=-m -o /dev/null . 2>&1
