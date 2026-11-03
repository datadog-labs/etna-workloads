cat > x_test.go <<'EOT'
package x

import "testing"

func f(x int) int { return x }

func g(x int) (int, int) { return x, x }

func Bench(b *testing.B) {
	for b.Loop() {
		_ = f(1)
		_, _ = g(1)
		_, _ = f(1), f(2)
	}
}
EOT
"$GO" test -trimpath -c -o /dev/null -gcflags=-m=2 x_test.go 2>&1 | grep -E 'kept alive'
