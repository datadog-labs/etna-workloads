#!/bin/bash
cat > repro_a.go <<'EOF'
package main
type O interface{}
type IO int
type OS int

type A struct {
	x int
}

// original versions of the two function
func (p *A) UO(o O) {
	p.r(o, o)
}
func (p *A) r(o1, o2 O) {
	switch x := o1.(type) {
	case *IO:
		p.x = int(*x)
	case *OS:
		p.x = int(*x + 2)
	}
}

// see note above about the importance of all this code winding up on one line.
var myverylongname0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 int ; func (p *A) UO2(o O) { p.r2(o, o); }; func (p *A) r2(o1, o2 O) { switch x := o1.(type) { case *IO:	p.x = int(*x); 	case *OS: 	p.x = int(*x + 2); } }

func main() {}
EOF
"$GO" build -trimpath -o /dev/null repro_a.go
