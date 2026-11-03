cat > p.go <<'EOT'
package p

func f() *int

var _ = [2]*int{nil, f()}

var _ = struct{ x, y *int }{nil, f()}

var _ interface{} = f()
EOT
"$GO" tool compile -p p -o p.o p.go 2>&1
echo "exit: $?"
