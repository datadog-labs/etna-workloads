printf 'module m\n\ngo 1.22\n' > go.mod
cat > x.go <<'F'
//go:build go1.19

package m

type Slice []byte
type Array [8]byte

var s Slice
var p = (Array)(s)
F
"$GO" build -trimpath ./... 2>&1
echo "exit=$?"
