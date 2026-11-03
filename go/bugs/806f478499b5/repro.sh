cat > x.go <<'EOT'
package p

type t struct{ x int }

func f2() (*t, error) {
	return t{}.M()
}
EOT
"$GO" build -trimpath -gcflags=-e ./x.go 2>&1; echo "exit $?"
