cat > x.go <<'XEOF'
package main

func main() {
	var i interface{} = new(T)
	if _, ok := i.(interface{ Bad() }); ok {
		panic("FAIL")
	}
	println("ok")
}

type T struct{ U }

type U struct{}

//go:nointerface
func (*U) Bad() {}
XEOF
GOEXPERIMENT=fieldtrack "$GO" run -trimpath x.go 2>&1
echo "exit=$?"
