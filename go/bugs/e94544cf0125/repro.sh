cat > x.go <<'EOG'
package main

import "unsafe"

func main() {
	var x [2]uint64
	a := unsafe.Pointer(&x[1])

	b := a
	b = unsafe.Pointer(uintptr(b) + 2)
	b = unsafe.Pointer(uintptr(b) - 1)
	b = unsafe.Pointer(uintptr(b) &^ 1)

	if a != b {
		panic("pointer arithmetic failed")
	}
	println("ok")
}
EOG
"$GO" run -trimpath -gcflags=-d=checkptr x.go 2>&1 | grep -E "^(ok|fatal)"
