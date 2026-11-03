cat > p.go <<'EOT'
package p

var foo = func() int {
label:
	goto label
	x := [1024 * 64]*[2]*int{}
	if x != x {
		_ = x
	}
	return 1
}()
EOT
"$GO" build -trimpath -o /dev/null ./p.go
echo "exit: $?"
