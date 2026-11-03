cat > x.go <<'EOT'
package p

type A [0]byte

func (a *A) Get(i int) byte {
	return a[i]
}
EOT
"$GO" build -trimpath -gcflags=-B ./x.go 2>&1
echo "exit $?"
