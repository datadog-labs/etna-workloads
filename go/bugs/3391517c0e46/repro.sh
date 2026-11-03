cat > x.go <<'EOT'
package p

import "unsafe"

type S[T any] struct{}

const c = unsafe.Sizeof(S[[c]byte]{})
EOT
"$GO" build -trimpath -gcflags=-e ./x.go 2>&1 | head -20
echo "exit: ${PIPESTATUS[0]}"
