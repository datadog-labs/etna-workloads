cat > p.go <<'EOT'
package p

func G[U any]() (u U) { return }

//go:noinline
func H[U any]() (u U) { return }

func F[T ~*[1]byte]() {
	_ = G[T]()[:]
	_ = H[T]()[:]
}

var _ = F[*[1]byte]
EOT
"$GO" build -trimpath -o /dev/null p.go 2>&1
echo "exit $?"
