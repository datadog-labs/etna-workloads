cat > x.go <<'EOT'
package p

type G[P any] struct{}

func f() {
	_ = new(U)
	_ = new(nil)
	_ = new(G)
	_ = new(comparable)
	_ = new(panic(0))
}
EOT
"$GO" build -gcflags=-lang=go1.25 ./x.go 2>&1
echo "exit=$?"
