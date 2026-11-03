cat > x.go <<'XEOF'
package p

func f() {
	var i int
	var s string
	for i > 0 {
		_ = s[0]
		i++
	}

	var c chan int
	c <- 1 % i
}

func f32() uint32 {
	s := "\x00\x00\x00\x00"
	c := uint32(s[0]) | uint32(s[1])<<8 | uint32(s[2])<<16 | uint32(s[3])<<24
	return 1 / c
}

func f64() uint64 {
	s := "\x00\x00\x00\x00\x00\x00\x00\x00"
	c := uint64(s[0]) | uint64(s[1])<<8 | uint64(s[2])<<16 | uint64(s[3])<<24 | uint64(s[4])<<32 | uint64(s[5])<<40 | uint64(s[6])<<48 | uint64(s[7])<<56
	return 1 / c
}
XEOF
"$GO" tool compile -p p -o /dev/null x.go > out.txt 2>&1
echo "exit: $?"
head -4 out.txt | sed 's/goroutine [0-9]*/goroutine N/'
