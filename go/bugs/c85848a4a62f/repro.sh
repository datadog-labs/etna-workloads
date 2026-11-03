cat > p.go <<'EOT'
package p

type Eq[T any] interface {
	Eqv(a T, b T) bool
}

type EqFunc[T any] func(a, b T) bool

func (r EqFunc[T]) Eqv(a, b T) bool {
	return r(a, b)
}

func New[T any](f func(a, b T) bool) Eq[T] {
	return EqFunc[T](f)
}

func Equal(a, b []byte) bool {
	return string(a) == string(b)
}

var Bytes Eq[[]byte] = New(Equal)
EOT
"$GO" tool compile -p p -trimpath "$PWD" -o /dev/null p.go 2>&1
echo "exit=$?"
