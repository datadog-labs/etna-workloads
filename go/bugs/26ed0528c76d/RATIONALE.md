# Rationale

Changed `src/cmd/compile/internal/types2/range.go` (go1.27.3 moved `rangeStmt` out of stmt.go).

Removed, in the ordinary-assignment branch (`for i = range 10`) for `rangeOverInt`, the post-assignment check
`if x.isValid() && !isInteger(x.typ()) { softErrorf(lhs, InvalidRangeExpr, "cannot use iteration variable of type %s", ...) }`.
This reverses the fix's hunk adding that check (go.dev/issues/67027). Pre-fix, the assignment `i = x` to a
float64 variable converted the untyped constant to float64 without error, so `for i = range 10` with
`var i float64` was accepted.

The other fix hunks (rangeOverInt rename, separate operand y) are refactors/already behaviour-preserving
in go1.27.3 and were left as is.

Failing oracle cases: TestSpec and TestSpec/range_int.go (missing expected error
"cannot use iteration variable of type float64" in issue66561 and issue67027 cases).
