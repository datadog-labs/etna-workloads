cat > x.go <<'EOG'
package p

func o() int {
	foo := func() int { return 1 }
	func(x int) {
		if x > 10 {
			foo = func() int { return 2 }
		}
	}(11)
	return foo()
}
EOG
"$GO" build -trimpath -gcflags="-m -d=inlfuncswithclosures=1" -o /dev/null x.go 2>&1
