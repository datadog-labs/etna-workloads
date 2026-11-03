cat > x.go <<'EOT'
package p

type S1 struct {
	a, b, c []int
	i       int
}

type S2 struct {
	a, b []int
	m    map[int]int
}

func F(i int, f func(S1, S2, int) int) int {
	return f(
		S1{},
		S2{m: map[int]int{}},
		1<<i)
}
EOT
"$GO" tool compile -p p -o /dev/null x.go 2>&1 | head -20
echo "exit ${PIPESTATUS[0]}"
