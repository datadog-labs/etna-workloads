cat > x.go <<'EOG'
package p

//go:noinline
func (f *Foo) Get2Vals() [2]int { return [2]int{f.Val, f.Val + 1} }
func (f *Foo) Get3Vals() [3]int { return [3]int{f.Val, f.Val + 1, f.Val + 2} }

type Foo struct{ Val int }

type Bar struct {
	int64
	*Foo
	string
}

var i any

func init() {
	i = Bar{1, nil, "first"}
}
EOG
"$GO" build -trimpath -gcflags=-d=tailcall=1 ./x.go 2>&1
echo "exit $?"
