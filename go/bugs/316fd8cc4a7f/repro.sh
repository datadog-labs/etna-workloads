cat > x.go <<'EOG'
package main

import (
	"fmt"
	"testing"
	"unsafe"
)

var buf [2]byte
var x unsafe.Pointer = unsafe.Pointer(&buf[0])

func main() {
	n := testing.AllocsPerRun(1000, func() {
		x = unsafe.Pointer(uintptr(x) + 1)
		x = unsafe.Pointer(uintptr(x) - 1)
	})
	fmt.Println("allocs:", n)
}
EOG
"$GO" run -trimpath -race x.go 2>&1
echo "exit: $?"
