cat > x.go <<'EOS'
package main

func o() int {
	foo := func() int { return 1 }
	func(x int) {
		if x > 10 {
			foo = func() int { return 2 }
		}
	}(11)
	return foo()
}

func main() { println(o()) }
EOS
"$GO" build -trimpath -gcflags=-m -o /dev/null x.go 2>&1
