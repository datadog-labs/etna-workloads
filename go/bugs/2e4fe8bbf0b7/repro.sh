cat > x.go <<'EOT'
package main

func min[T int | float64](a, b T) T {
	if a < b {
		return a
	}
	return b
}

func main() {
	println(min(1, 2.5))
}
EOT
"$GO" build -trimpath -gcflags=-lang=go1.20 -o x.out ./x.go 2>&1
echo "exit=$?"
