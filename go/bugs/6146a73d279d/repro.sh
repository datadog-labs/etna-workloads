cat > x.go <<'EOT'
package p

func f() {
	for range 10 {
	}
}
EOT
"$GO" build -trimpath -gcflags=-lang=go1.21 ./x.go
echo "exit=$?"
