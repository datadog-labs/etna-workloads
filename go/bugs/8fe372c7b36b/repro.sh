export GOCACHE="$PWD/.gocache"
cat > x.go <<'EOT'
package main

type T1 struct{}

func (a T1) meth(val int) int { return val + 5 }

func getMeth(t1 T1) func(int) int { return t1.meth }

func main() {
	var t1 T1
	f := getMeth(t1)
	println(f(3))
}
EOT
"$GO" build -trimpath -gcflags=-m -o /dev/null x.go 2>&1
