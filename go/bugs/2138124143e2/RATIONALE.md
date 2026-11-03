# Rationale

Changed `keyVal` in `src/cmd/compile/internal/types2/expr.go` back to its pre-fix form.
This reverses the fix's types2 `expr.go` hunk (go/types is outside src/cmd/compile).
The code in go1.27.3 was identical to the fix, so the old body (with the TODO about
#51610) was restored: no Complex->Float->Int narrowing, so 1, 1.0 and 1+0i give different
map keys (int64, float64, complex128) and are not detected as duplicates for a
type-parameter key type.

Oracle failures: `TestFixedbugs/issue51610.go` (and parent `TestFixedbugs`): the expected
"duplicate key" errors are not reported.
