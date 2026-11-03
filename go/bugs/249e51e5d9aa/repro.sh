mkdir -p m
cat > a.go <<'EOM'
package a

type A struct {
	New func() any
}

func NewA(i int) *A {
	return &A{
		New: func() any {
			_ = i
			return nil
		},
	}
}
EOM
cat > b.go <<'EOM'
package b

import "m/a"

var _ = a.NewA(0)
EOM
"$GO" tool compile -p m/a -o m/a.o a.go 2>&1
"$GO" tool compile -p b -I . -o b.o b.go 2>&1
echo "rc=$?"
