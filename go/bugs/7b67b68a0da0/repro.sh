cat > x.go <<'EOF'
package main

func issue76688(x, y uint64) uint64 {
	if x > 1 || y != 1<<63 {
		return 42
	}
	return x * y
}

func main() { println(issue76688(1, 1<<63)) }
EOF
"$GO" build -a -trimpath -gcflags=-d=ssa/prove/debug=1 x.go 2>&1 | grep -v 'go.mod'
