mkdir -p a
cat > go.mod <<'X'
module repro

go 1.22
X
cat > a/a.go <<'X'
package a

var s any

//go:noinline
func F() {
	s = new([4]int32)
}
X
cat > main.go <<'X'
package main

import (
	"reflect"

	"repro/a"
)

var s = []rune{0, 1, 2, 3}

func main() {
	m := map[any]int{}
	k := reflect.New(reflect.ArrayOf(4, reflect.TypeOf(int32(0)))).Elem().Interface()
	m[k] = 1
	a.F()
	println("ok", len(s))
}
X
"$GO" run -trimpath . 2>&1
echo "exit=$?"
