# Use a private build cache: the two toolchains report the same version,
# so a shared cache could serve one toolchain's output to the other.
export GOCACHE="$PWD/gocache"
cat > repro.go <<'EOG'
package main

type Conn interface{ Hello() }

type PoolConn struct{ Conn }
type CustomConn struct{}

func (p CustomConn) Hello() { println("called") }

//go:noinline
func get() func(*PoolConn) { return (*PoolConn).Hello }

//go:noinline
func mk(x any) *PoolConn { return &PoolConn{Conn: x.(Conn)} }

func main() {
	p := mk(CustomConn{})
	get()(p)
}
EOG
"$GO" build -trimpath -o repro.bin repro.go && out=$(./repro.bin 2>&1); st=$?
printf '%s\n' "$out" | head -1
exit $st
