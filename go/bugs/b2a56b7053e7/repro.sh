cat > p.go <<'X'
package p

func f(p []byte) int {
	switch "" < string(p) {
	case true:
		return 0
	default:
		return 1
	}
}
X
"$GO" build -trimpath -o /dev/null p.go 2>&1
echo "exit=$?"
