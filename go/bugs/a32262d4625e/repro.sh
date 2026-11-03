cat > repro.go <<'EOG'
package main

import (
	"fmt"
	"reflect"
)

var called bool

type foo struct{}

func (foo) X() { called = true }

var h = reflect.Type.Method

func main() {
	v := reflect.ValueOf(foo{})
	m := h(v.Type(), 0)
	f := m.Func.Interface().(func(foo))
	f(foo{})
	fmt.Println("called:", called)
}
EOG
"$GO" build -trimpath -o repro.bin repro.go || exit 1
./repro.bin 2>&1 | head -1
echo "status: ${PIPESTATUS[0]}"
