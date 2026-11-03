cat > x.go <<'EOT'
package p

import . "testing"

type S struct {
	T int
}

var _ = S{T: 0}
EOT
"$GO" build -trimpath -gcflags=-e ./x.go
echo "exit=$?"
