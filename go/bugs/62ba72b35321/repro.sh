mkdir a
cat > go.mod <<'X'
module m
go 1.20
X
cat > a/a.go <<'X'
package a

type T1 struct {
	*T2
}

type T2 struct{}

func (t2 *T2) M() {}

func F() {
	f(T1.M)
}

func f(f func(T1)) {}
X
"$GO" build -trimpath -gcflags=-m ./a 2>&1
echo "exit: $?"
