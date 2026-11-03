cat > x.go <<'EOT'
package foo

var sink *(*int)

func f(p *int) (r *int) {
	sink = &r
	return p
}
EOT
"$GO" build -trimpath -gcflags=-m -o /dev/null x.go 2>&1
