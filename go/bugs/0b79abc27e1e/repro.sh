cat > b.go <<'XX'
package main

type T struct {
	m map[int]int
}

func main() {
	t := T{
		m: make(map[int]int),
	}
	t.Inc(5)
	t.Inc(7)
}

func (s *T) Inc(key int) {
	v := s.m[key]
	v++
	s.m[key] = v
}
XX
"$GO" build -trimpath -gcflags="-N -l -S" -o /dev/null b.go 2>&1 | awk '/^main\.\(\*T\)\.Inc STEXT/{p=1;next} /STEXT/{p=0} p && match($0,/b\.go:[0-9]+/) {print substr($0,RSTART,RLENGTH), $4}'
