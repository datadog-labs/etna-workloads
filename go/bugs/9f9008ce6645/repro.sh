cat > x.go <<'XEOF'
package main

type A[P any] [1]P

type B[P any] A[P]

type C B[C]

func main() {}
XEOF
# Print only the stable diagnostic lines (the buggy compiler overflows its stack
# and dumps nondeterministic goroutine traces).
"$GO" build -trimpath -o /dev/null ./x.go 2>&1 | grep -E '^(\./x\.go|fatal error|\s+\./x\.go)'
echo "status ${PIPESTATUS[0]}"
