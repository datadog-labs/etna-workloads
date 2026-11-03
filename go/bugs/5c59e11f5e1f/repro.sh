set -e
mkdir -p a b
cat > go.mod <<'M'
module m
go 1.20
M
for p in a b; do
cat > $p/$p.go <<P
package $p

func F() interface{} { return struct{ _ []int }{} }

var X = F()
P
done
cat > main.go <<'M'
package main

import (
	"fmt"
	"m/a"
	"m/b"
)

func main() {
	fmt.Println(a.F() == b.F(), a.X == b.X)
}
M
"$GO" run -trimpath . 2>&1 || echo "exit $?"
