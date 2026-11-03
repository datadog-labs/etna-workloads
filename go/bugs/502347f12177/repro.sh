cat > go.mod <<'EOT'
module p

go 1.13
EOT
cat > p.go <<'EOT'
package p

import "io"

type R interface {
	Read(p []byte) (n int, err error)
}

type _ interface {
	R
	io.Reader
}
EOT
"$GO" build -trimpath ./... 2>&1
echo "exit=$?"
