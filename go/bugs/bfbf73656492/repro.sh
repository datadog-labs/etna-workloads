cat > x.go <<'EOT'
package x

func F[T int32]() {
	_ = G[*[0]T]()[:]
}

func G[T any]() (v T) {
	return
}

var _ = F[int32]
EOT
"$GO" build -trimpath -o /dev/null x.go 2>&1
echo "exit=$?"
