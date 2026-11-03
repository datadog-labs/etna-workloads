cat > issue67141.go <<'EOT'
//go:build go1.21

//line issue67141.go:10
package p

func _() {
	for range 10 {
	}
}
EOT
"$GO" build -trimpath -gcflags=-lang=go1.22 ./issue67141.go
echo "exit: $?"
