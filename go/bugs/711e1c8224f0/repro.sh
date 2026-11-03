cat > x.go <<'EOT'
package p

func F()

//go:noescape
func f() {}
EOT
"$GO" tool compile -complete -p p x.go
echo "exit=$?"
