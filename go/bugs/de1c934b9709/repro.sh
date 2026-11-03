cat > x.go <<'EOG'
package main

import (
	"fmt"
	"unsafe"
)

func main() {
	defer func() {
		fmt.Println("recovered:", recover())
	}()
	s := make([]int64, 100)
	p := unsafe.Pointer(&s[0])
	n := 1000

	_ = (*[10]int64)(p)[:n:n]
}
EOG
"$GO" run -trimpath -gcflags=-d=checkptr x.go 2>&1 | grep -E "^(recovered|fatal error)"
echo "exit: ${PIPESTATUS[0]}"
