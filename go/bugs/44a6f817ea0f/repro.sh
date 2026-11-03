cat > x.go <<'XEOF'
package p

type S struct {
	a, b string
	c    *int
}

var g1, g2 *int

func f(dst *S, ptr *int) {
	_ = *dst
	var s S
	sp := &s
	g1 = nil
	sp.c = ptr // not write-barrier eligible
	g2 = nil
	*dst = *sp
}
XEOF
"$GO" tool compile -p p -trimpath "$PWD" -S x.go 2>&1 | grep -E '^\s+0x.*CALL.*(gcWriteBarrier|wbMove)' | sed -E 's/^\s+0x[0-9a-f]+ [0-9]+ //'
