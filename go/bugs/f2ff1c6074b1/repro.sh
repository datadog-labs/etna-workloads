cat > x.go <<'EOT'
package p

func f() {
	go copy([]int{1: 0}, []int{})
}
EOT
"$GO" build -trimpath -gcflags=-e ./x.go
echo "exit=$?"
