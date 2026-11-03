cat > go.mod <<'X'
module m

go 1.17
X
cat > x.go <<'X'
package main

func f[P any](P) {}

var v func(int) = f

func main() { v(1) }
X
"$GO" build -trimpath -o /dev/null . 2>&1
echo "exit: $?"
