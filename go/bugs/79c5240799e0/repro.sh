set -e
mkdir -p a b c
cat > go.mod <<'M'
module m
go 1.20
M
cat > a/a.go <<'E'
package a

type T[P any] struct{ x P }
E
for p in b c; do
cat > $p/$p.go <<E
package $p

import "m/a"

//go:noinline
func F() interface{} { return a.T[int]{} }
E
done
cat > main.go <<'E'
package main

import (
	"m/b"
	"m/c"
)

func main() {
	println(b.F() == c.F())
}
E
"$GO" build -trimpath -o out . 2>&1
./out 2>&1
echo "exit $?"
