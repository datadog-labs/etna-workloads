# Rationale

Fix hunk reversed: types2/expr.go `comparison` — the early return for operands of invalid type (issue 54405).
In go1.27.3 it reads `if !isValid(x.typ()) || !isValid(y.typ()) { x.invalidate(); return }`; I removed it
(the go/types copy is generated from types2, so only types2 is changed under src/cmd/compile).
Without it, `x.f == nil` with `f *NotAType` reports spurious comparison errors on top of the "undeclared name" error.

Oracle failures: TestFixedbugs and TestFixedbugs/issue54405.go (types2).
