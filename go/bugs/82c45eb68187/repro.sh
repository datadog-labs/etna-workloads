cat > x.go <<'EOT'
package p

type t [20000]*int

func (t) f() {
}

func x() {
	x := t{}.f
	x()
}

func z() {
	var i int
	z := t{&i}.f
	z()
}
EOT
"$GO" build -trimpath -gcflags='-m -l' ./x.go 2>&1
echo "exit: $?"
