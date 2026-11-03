mkdir -p a
cat > go.mod <<'M'
module m

go 1.22
M
cat > a/a.go <<'M'
package a

func One(L any) {
	func() {
		defer F(L)
	}()
}

func F(any) {}
M
cat > main.go <<'M'
package main

import "m/a"

func main() {
	a.One(nil)
	Two(nil)
	println("ok")
}

func Two(L any) {
	func() {
		defer a.F(L)
	}()
}
M
"$GO" run -trimpath . 2>&1
echo "exit=$?"
