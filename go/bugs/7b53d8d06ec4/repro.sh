mkdir -p a b
cat > a/a.go <<'EOT'
package a

type A[_ B[any]] struct{}

type B[_ any] interface {
	f() A[B[any]]
}
EOT
cat > b/b.go <<'EOT'
package b

import "a"

var _ a.A[a.B[any]]
EOT
cat > go.mod <<'EOT'
module m
go 1.24
EOT
mkdir -p x && mv a b x/ 
cd x
sed -i 's/import "a"/import "m\/a"/' b/b.go
cd ..
mv x/a x/b . ; rmdir x
"$GO" build -trimpath ./b 2>&1 | head -20
echo "exit: ${PIPESTATUS[0]}"
