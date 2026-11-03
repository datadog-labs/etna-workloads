cat > x.go <<'EOT'
package main

func issue76269(a, b []byte) byte {
	idxA := len(a) - 1
	idxB := len(b) - 1
	c := byte(0)
	for idxA >= 0 && idxB >= 0 {
		c ^= a[idxA]
		c ^= b[idxB]
		idxA--
		idxB--
	}
	return c
}

func main() { println(issue76269([]byte{1, 2}, []byte{3})) }
EOT
"$GO" build -trimpath -gcflags=-d=ssa/prove/debug=1 -o /dev/null x.go 2>&1
