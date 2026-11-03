cat > x.go <<'EOS'
package p

func F[P any, Q *P](p P) {}

var _ = F[int]

func G[R any](func(R)) {}

func _() {
	G(F[int])
}
EOS
"$GO" build -gcflags=-lang=go1.20 ./x.go
echo "exit $?"
