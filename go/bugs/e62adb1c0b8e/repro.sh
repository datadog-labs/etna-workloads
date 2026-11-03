cat > x.go <<'EOG'
package p

type I interface{ M() }
type T struct{ I }

func f() {
	var i I = T{}
	i.M()
}
EOG
"$GO" build -trimpath -gcflags=-m x.go 2>&1
echo "exit=$?"
