# Rationale

Fix hunk reversed: `types2/check.go` `recordCommaOkTypes` assert, `allBoolean(t1)` -> `isBoolean(t1)`.
In go1.27.3 the function lives in `src/cmd/compile/internal/types2/recording.go` (line 101); the
one-token change restores the pre-fix assertion. For a type-parameter `T ~bool`, `isBoolean` is false
(it only tests the underlying basic type), so the assert fires on `var x, ok T = <-ch` / `m[0]`.
(The go/types copy is outside src/cmd/compile and is not touched.)

Oracle: TestFixedbugs/issue66878.go fails (assertion panic in recordCommaOkTypes), and the panic
aborts the test binary, so many other cases in the package are reported failing as well.
