# Rationale

Fix: checkptr false positive on `p &^ x`. Pre-fix, walk lowered OANDNOT to
OAND (with OBITNOT on the right) and walkCheckPtrArithmetic only recognised
OSUB/OANDNOT, so the lowered `&^` no longer matched and the original
unsafe.Pointer was not collected, which produced a false "pointer arithmetic
result points to invalid allocation".

In go1.27.3 walk no longer lowers OANDNOT (ssagen handles it directly), and
walkCheckPtrArithmetic (walk/convert.go) still handles OANDNOT, so the bug
was gone. Change, in `walk/expr.go` (walkExpr, binary-op case): restore the old
lowering, OANDNOT -> OAND with `Y = ^Y`, and do NOT mark it Implicit. This
reverses the fix's walk.go hunk (`n.SetImplicit(true)`) by returning to the
pre-fix lowering. The checkptr walker's `case OSUB, OANDNOT` is left
unchanged: it is equivalent to the pre-fix code, where the lowered OAND is
not matched.

The fix's syntax.go hunk only changed a comment, so nothing was reverted there.

## Oracle
`test/fixedbugs/issue40917.go` (`-d=checkptr`) fails: `unsafe.Pointer(uintptr(b) &^ 1)`
now raises a checkptr fatal error, so the program crashes instead of running
cleanly. `TestShouldTest` still passes.
