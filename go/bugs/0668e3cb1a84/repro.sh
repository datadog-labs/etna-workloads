cat > x.go <<'EOG'
package x

type T struct {
	a *[10]int
}

func F1(t *T) {
	for i := range t.a {
		t.a[i] = 0
	}
}

func F2(t *T) {
	for i := range *t.a {
		(*t.a)[i] = 0
	}
}

func F3(p *[10]int) {
	for i := range p {
		p[i] = 0
	}
}
EOG
"$GO" tool compile -p x -S x.go 2>&1 | grep -E 'STEXT|memclrNoHeapPointers' | sed 's/ args=.*//'
