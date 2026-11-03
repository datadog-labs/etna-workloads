cat > x.go <<'EOT'
package foo

import "testing"

func caninline(x int) int {
	return x
}

func test(b *testing.B, localsink int) {
	for b.Loop() {
		caninline(1)
		localsink += 5
	}
}
EOT
"$GO" build -trimpath -gcflags=-m=2 -o /dev/null x.go 2>&1 | grep -E 'kept alive|escape'
echo "exit: ${PIPESTATUS[0]}"
