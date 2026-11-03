# Rationale

Fix (issue 38745): don't report "not enough arguments/return values" when the
call being returned is itself undefined (its type is invalid/nil).
The old gc check `n.Type != nil` now lives in types2 `initVars`
(src/cmd/compile/internal/types2/assignments.go), as the guard
`rhs[0].mode() != invalid` before reporting a count mismatch.

Change: in the final mismatch block of `initVars`, the guard is dropped for
return statements, so `returnError` is reported even when the single call on the
rhs is invalid (assignments still keep the guard). This restores the pre-fix
behaviour: a spurious second error alongside "t{}.M undefined".

Oracle: test/fixedbugs/issue38745.go fails with an unmatched extra error
"not enough return values / have (unknown type)" at `return t{}.M()`.
test/ddd1.go still passes (a different path, the call-args check, is unchanged).
