# Rationale

Fix hunk: in `ascompatee` (walk/assign.go), walk the lhs init statements
(`walkStmtList(l.Init())`, `early.Append(ir.TakeInit(l)...)`) before saving
lhs subexpressions (#45706).

In go1.27.3 this is the loop body `init := ir.TakeInit(l); walkStmtList(init);
early.Append(init...)` at the top of the "drill through non-dereferences" loop
in `src/cmd/compile/internal/walk/assign.go`. I removed those lines (and their
comment), restoring the pre-fix behaviour: lhs init statements are never
walked/hoisted into `early`, so they are evaluated after the saved
sub-operands (or not walked at all).

Oracle: `test/fixedbugs/issue45706.go` fails with
`internal compiler error: 'h': value .autotmp_5 (v88) incorrectly live at entry`.
`TestShouldTest` passes.
