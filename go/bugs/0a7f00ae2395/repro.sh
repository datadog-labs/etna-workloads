set -e
mkdir -p a b
cat > go.mod <<'X'
module m

go 1.27
X
cat > a/a.go <<'X'
package a

func A() {
	var m map[int]int = map[int]int{
		0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0,
		10: 0, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0, 16: 0, 17: 0, 18: 0, 19: 0,
		20: 0, 21: 0, 22: 0, 23: 0, 24: 0, 25: 0, 26: 0, 27: 0, 28: 0, 29: 0}
	if len(m) != 30 {
		panic("unexpected map length")
	}
}
X
cat > b/b.go <<'X'
package b

import "reflect"

func B() {
	t1 := reflect.TypeOf([30]int{})
	t2 := reflect.TypeOf(new([30]int)).Elem()
	if t1 != t2 {
		panic("[30]int types do not match")
	}
}
X
cat > main.go <<'X'
package main

import (
	"m/a"
	"m/b"
)

func main() {
	a.A()
	b.B()
	println("ok")
}
X
"$GO" run -trimpath . 2>&1
