# Rationale

The fix's single hunk in `elimDeadAutosGeneric` (src/cmd/compile/internal/ssa/deadstore.go) is still present in go1.27.3 at the same condition. I reversed it in place:

`if v.Uses == 0 && v.Op != OpNilCheck && !v.Op.IsCall() && !v.Op.HasSideEffects() || len(args) == 0`
back to
`if v.Uses == 0 && v.Op != OpNilCheck || len(args) == 0`

(and removed the matching comment line). Use-less calls and side-effecting values that take the address of an auto are again skipped, so the auto can be eliminated while the call is kept.

## Oracle
`test/fixedbugs/issue45693.go` fails: `internal compiler error: bad live variable at entry of f: [6]string value`.
