cat > p.go <<'EOF'
package p

type T struct {
	a any
	s string
}

func f(x int, s string) {
	_ = [...]T{{a: x, s: s + "a"}, {a: s}}
}
EOF
"$GO" tool compile -p p -o /dev/null p.go
echo "exit=$?"
