set -e
mkdir -p a b
cat > go.mod <<'X'
module m

go 1.27
X
cat > a/a.go <<'X'
package a

type S struct{}

func callClosure(closure func()) {
	closure()
}

func (s *S) M() {
	callClosure(func() {
		defer f(s.m) // prevent closures to be inlined.
	})
}

func (s *S) m() {}

//go:noinline
func f(a ...any) {}
X
cat > b/b.go <<'X'
package b

import "m/a"

var _ = (&a.S{}).M
X
cat > main.go <<'X'
package main

import _ "m/b"

func main() { println("ok") }
X
"$GO" build -trimpath -o prog . 2>&1
echo "build exit: $?"
./prog
