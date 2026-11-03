cat > x.go <<'EOT'
package main

type T struct {
	A
}

type A struct {
}

//go:noinline
func (a *A) Foo(s [2]string) {
}

func main() {}
EOT
"$GO" build -trimpath -gcflags=-d=libfuzzer ./x.go
echo "exit $?"
