cat > x.go <<'EOT'
package p

import "unsafe"

func main() {
	_ = unsafe.Add(unsafe.Pointer(nil), 0)
	_ = unsafe.Slice(new(byte), 1)
}
EOT
"$GO" build -trimpath -gcflags=-lang=go1.16 -o /dev/null ./x.go
echo "exit $?"
