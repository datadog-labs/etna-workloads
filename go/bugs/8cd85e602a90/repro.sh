export GOCACHE="$PWD/.gocache"
cat > x.go <<'EOT'
package main

func issue74473(s []uint) {
	i := 0
	for {
		if i >= len(s) {
			break
		}
		_ = s[i]
		i++
	}
}

func main() {}
EOT
"$GO" build -trimpath -gcflags=-d=ssa/prove/debug=1 x.go 2>&1 | grep -v STOREORDER
