set -e
mkdir -p a
cat > go.mod <<'M'
module m

go 1.20
M
cat > a/a.go <<'M'
package a

var s string

func init() { s = "a" }

func Get() string { return s }
M
cat > main.go <<'M'
package main

import (
	"m/a"
	_ "unsafe"
)

//go:linkname s m/a.s
var s string

func main() {
	if a.Get() != "a" {
		panic("FAIL1")
	}
	s = "b"
	if a.Get() != "b" {
		panic("FAIL2")
	}
	println("ok")
}
M
"$GO" run -trimpath . 2>&1
echo "exit=$?"
