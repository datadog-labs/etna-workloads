set -e
mkdir -p a b p
cat > go.mod <<'X'
module m
go 1.20
X
cat > a/a.go <<'X'
package a

type I interface{}

type F func()

type s struct {
	f F
}

func NewWithF(f F) *s {
	return &s{f: f}
}

func NewWithFuncI(func() I) *s {
	return &s{}
}
X
cat > b/b.go <<'X'
package b

import "m/a"

type S struct{}

func (s *S) M1() a.I {
	return a.NewWithF(s.M2)
}

func (s *S) M2() {}
X
cat > p/p.go <<'X'
package p

import (
	"m/a"
	"m/b"
)

func F() {
	a.NewWithFuncI((&b.S{}).M1)
}
X
mkdir -p main
cat > main/main.go <<'X'
package main

import "m/p"

func main() { p.F() }
X
"$GO" run -trimpath ./main 2>&1
echo "exit=$?"
