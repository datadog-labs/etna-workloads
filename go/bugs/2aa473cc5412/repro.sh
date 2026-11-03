cat > x.go <<'EOT'
package main

import (
	"fmt"
	"sync/atomic"
	"unsafe"
)

var s struct {
	x int32
	y atomic.Int64
	z int64
}

const (
	offY = unsafe.Offsetof(s.y)
	offZ = unsafe.Offsetof(s.z)
	size = unsafe.Sizeof(s)
)

func main() {
	fmt.Println(offY, offZ, size)
	fmt.Println(unsafe.Offsetof(s.y), unsafe.Offsetof(s.z), unsafe.Sizeof(s))
}
EOT
GOARCH=386 "$GO" build -trimpath -o x386 x.go && ./x386
