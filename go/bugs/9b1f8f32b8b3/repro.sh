cat > repro.go <<'EOM'
//go:build go1.21

package main

func f[T comparable]() {}

func main() {
	f[any]()
}
EOM
"$GO" tool compile -lang=go1.19 -o /dev/null repro.go
echo "exit=$?"
