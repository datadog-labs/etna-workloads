# Rationale

Fix (go.dev/issue/59371): initVars/assignVars must only call recordCommaOkTypes
when both rhs operands are still valid after initVar/assignVar.

Changed (src/cmd/compile/internal/types2/assignments.go), two hunks:
- initVars: `if commaOk && rhs[0].mode() != invalid && rhs[1].mode() != invalid` -> `if commaOk`
  (reverses the fix's initVars hunk).
- assignVars: same guard removed (reverses the fix's assignVars hunk).

The x.mode invalidation in initVar/assignVar still exists in go1.27.3 (now via
x.invalidate()), but without the guard the failed comma-ok assignment is recorded anyway,
as before the fix. go/types is not touched (outside src/cmd/compile).

Oracle: TestFixedbugs/issue59371.go fails with a panic (assertion in recordCommaOkTypes,
e.g. `_, ok = m[0]` with undefined ok), which takes down the whole types2 test binary, so
many other cases (listed by check.sh) also fail.
