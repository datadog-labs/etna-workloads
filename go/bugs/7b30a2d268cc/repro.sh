cat > x.go <<'EOG'
package x

func f() {
	i := 2
	s := make([]int, i, 3)
	_ = s
}
EOG
"$GO" build -trimpath -gcflags=-m -o /dev/null x.go 2>&1
echo "exit=$?"
