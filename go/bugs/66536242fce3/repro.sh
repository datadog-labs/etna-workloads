cat > a.go <<'XX'
package main

import "runtime"

func main() {
	a := 1
	runtime.Breakpoint()
	sink = a
}

var sink any
XX
"$GO" build -trimpath -gcflags='-N -l -S' -o /dev/null a.go 2>&1 | awk '/^main\.main STEXT/{f=1;next} f&&/^[^\t]/{f=0} f' | grep -oE '\(\./a\.go:[0-9]+\)' | uniq | tr '\n' ' '
echo
