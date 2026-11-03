cat > x.go <<'XEOF'
package main

var p *[1 << 50]byte

func main() {
	println(p == nil)
}
XEOF
"$GO" build -trimpath -o x.out x.go 2>&1 | grep -v '^go: warning'
echo "exit=${PIPESTATUS[0]}"
