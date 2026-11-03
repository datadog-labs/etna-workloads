cat > x.go <<'EOT'
package p

type T[P any] interface{}

func f1[P any](T[P])    {}
func f2[P any](T[P], P) {}

func _() {
	var t T[int]
	f1(t)

	var s string
	f2(t, s)
}
EOT
"$GO" build -trimpath -gcflags=-lang=go1.20 -o /dev/null x.go
echo "exit $?"
