# Rationale

## Change
`tree/src/cmd/compile/internal/types2/builtins.go`, `case _Max, _Min`: removed the loop
`for _, a := range args { check.updateExprType(a.expr, x.typ(), true) }` ("Use the final type
computed above for all arguments").

This reverses the types2 hunk of the fix, which added exactly that loop. The code is the same as
at fix time apart from `x.typ()`/`x.mode()` now being accessors. The go/types hunk is outside
src/cmd/compile/, so it is not touched.

## Oracle
`test/fixedbugs/issue60991.go` (`min(0.1, 0.2, math.Sqrt(1))`) fails: the untyped constant
arguments never get their final type float64 recorded, so the compiler hits
"internal compiler error: assertion failed". `TestShouldTest` passes (it is not a bug case).
