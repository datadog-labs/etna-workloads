cat > x.go <<'EOT'
package x

func fa(a [2]int) (r [2]int) {
	return a
}

func fb(a [4]int) (r [4]int) {
	return a
}
EOT
# Count the MOVUPS instructions emitted for each function and show its size.
"$GO" tool compile -S -p x x.go | awk '
/^x\.f[ab] STEXT/ { fn = $1; sz = $5; n[fn] = 0; s[fn] = sz }
/\tMOVUPS\t/ && fn != "" { n[fn]++ }
/^x\.f[ab]\.arginfo1/ { fn = "" }
END { for (f in n) print f, s[f], "MOVUPS=" n[f] }' | sort
