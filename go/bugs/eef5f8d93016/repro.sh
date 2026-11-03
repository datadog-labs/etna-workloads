cat > x.go <<'EOT'
package main

type T struct {
	a [20]int
}

func f(x [4]int) {
	g(T{}, x)
}

func g(t T, x [4]int)

func main() {}
EOT
cat > go.mod <<'EOT'
module x
go 1.20
EOT
: > x_amd64.s
"$GO" build -trimpath -o /dev/null . 2>&1 | head -5
echo "exit: ${PIPESTATUS[0]}"
