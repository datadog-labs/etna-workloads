set -e
mkdir -p a
cat > go.mod <<'M'
module m
go 1.21
M
cat > a/a.go <<'X'
package a

func F[T any]() {
}
X
cat > main.go <<'X'
package main

import "m/a"

func main() {
	a.F[int]()
	println("ok")
}
X
"$GO" run -trimpath . 2>&1
echo "exit $?"
