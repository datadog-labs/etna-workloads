cat > x.go <<'X'
package p

func f() {
	var x string
	func() [10][]bool {
		return [10][]bool{
			[]bool{bool(x < "")},
			[]bool{}, []bool{}, []bool{}, []bool{}}
	}()
}
X
"$GO" build -trimpath -o /dev/null ./x.go 2>&1
echo "exit $?"
