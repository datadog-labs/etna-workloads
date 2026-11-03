cat > x.go <<'XEOF'
package p

type T int

func (T) Mv()  {}
func (*T) Mp() {}

func _() {
	type P7 *struct{ T }
	type P8 *struct{ *T }
	var p P7
	p.Mv()
	p.Mp()
	(&p).Mv()
	var q P8
	q.Mv()
	q.Mp()
	(*p).Mv()
}
XEOF
"$GO" build -trimpath -gcflags=-e ./x.go 2>&1
echo "exit=$?"
