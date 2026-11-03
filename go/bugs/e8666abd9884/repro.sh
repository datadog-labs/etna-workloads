cat > x.go <<'EOT'
package p

func f() {
	var s string
	s = s + "" + s + "" + s + ""
	for {
	}
}
EOT
"$GO" build -trimpath -o /dev/null ./x.go
echo "exit $?"
