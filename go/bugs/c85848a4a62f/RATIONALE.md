# Rationale

## Hunk: src/cmd/compile/internal/staticinit/sched.go (StaticAssign, case ir.OCONVIFACE)
Reverses the fix's added check. In go1.27.3 the check is `if val.Type().HasShape() { return false }` (the `base.Debug.Unified != 0` condition has since been dropped because unified IR is the only frontend). I removed it, so a conversion to interface of a shape-typed value inside an inlined generic call is statically initialised even though it needs a runtime dictionary.

## Oracle
test/fixedbugs/issue56923.go fails: `internal compiler error: shape types have no methods p.EqFunc[go.shape.[]uint8]` at `var Bytes Eq[[]byte] = New(Equal)`. This is the failure the fix guarded against. TestShouldTest passes, as expected.
