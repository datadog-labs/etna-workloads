cat > x.go <<'EOF'
package p

func p() {
	s := make([]int, copy([]byte{' '}, "")-1)
	_ = append([]int{}, make([]int, len(s))...)
}
EOF
"$GO" build -trimpath -o /dev/null x.go 2>&1
echo "exit $?"
