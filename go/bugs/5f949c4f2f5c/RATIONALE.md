# Rationale

Fix (golang/go#65133): range over a constant integer expression with no iteration
variables skipped validation, so e.g. `for range maxUint {}` (overflows int) was accepted.

## Change: src/cmd/compile/internal/types2/range.go (rangeStmt)
Removed the trailing `else if rangeOverInt { check.assignment(&x, nil, "range clause") }`
branch. This reverses the fix hunk adding `else if constIntRange { ... check.assignment(&x, nil, "range clause") }`
(the "no iteration variables" case). In go1.27.3 the other hunks (context parameter to assignVar,
"range clause" for initVar/assignVar of the range expr) are still present and unchanged; only this branch was
the missing piece before the fix. `constIntRange` is now spelled `rangeOverInt`.

## Oracle failures
TestSpec and TestSpec/range_int.go (types2) fail: the `issue65133` cases `for range maxInt + 1 {}` and
`for range maxUint {}` no longer report "cannot use ... as int value in range clause (overflows)".
