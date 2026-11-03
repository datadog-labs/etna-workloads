cat > p.go <<'EOG'
package p

type A = int

type T[P any] *A

var _ T[int]
EOG
"$GO" build -trimpath -o /dev/null p.go 2>&1 | grep -E "^(#|fatal error)"
echo "exit=${PIPESTATUS[0]}"
