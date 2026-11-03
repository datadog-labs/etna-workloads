mkdir -p a b
cat > a/a.go <<'X'
package a

func F() interface{} { return new(T[int]) }

type T[P any] int

func (x *T[P]) One() int { return x.Two() }
func (x *T[P]) Two() int { return 0 }
X
cat > b/b.go <<'X'
package b

import "a"

var _ = a.F()
X
"$GO" tool compile -p a -o a.a a/a.go; echo "a exit $?"
"$GO" tool compile -p b -I . -o b.a b/b.go; echo "b exit $?"
