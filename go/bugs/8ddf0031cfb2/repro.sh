cat > x.go <<'EOT'
package main

type Fooer interface {
	Foo() string
}

type FooImpl struct{}

//go:nointerface
func (FooImpl) Foo() string { return "foo" }

func toInterface[T Fooer](fooer T) Fooer {
	return fooer
}

func main() {
	var iface Fooer = toInterface(FooImpl{})
	iface.Foo()
}
EOT
GOEXPERIMENT=fieldtrack "$GO" build -trimpath -o /dev/null x.go 2>&1
echo "exit=$?"
