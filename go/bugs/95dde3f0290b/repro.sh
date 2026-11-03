cat > x.go <<'EOT'
package p

func f() {
	_ = func() func() {
		return func() {
		l:
			goto l
		}
	}()
}
EOT
"$GO" build -trimpath -gcflags=-p=p -o x.a x.go 2>&1 | head -3
echo "exit: ${PIPESTATUS[0]}"
