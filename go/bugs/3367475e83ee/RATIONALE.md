# Rationale

Only file changed: `tree/src/cmd/compile/internal/types2/call.go` (`funcInst`).

Reverses the fix's `call.go` hunks (types2 side):
- Condition: restores the arity check `T.sig.params.Len() == sig.params.Len() && T.sig.results.Len() == sig.results.Len()`.
- Synthetic call: replaces the single `g'(func(p1,...))` argument with the old
  per-parameter/per-result synthetic call `g(t1, t2, ..., r1, ...)`. Each target
  param/result type becomes an operand assigned to the matching param/result of x, so
  unification uses inexact (assignment) rules and e.g. `mystring` matches `string`.
- Re-adds `paramName` (using the existing `nth(n, what)` helper in expr.go, which
  now replaces the removed `nth`) for the pseudo-expression names.
The `reverse` flag in infer is kept untouched.

Oracle cases failing: TestExamples/inference2.go, TestFixedbugs/issue60688.go,
TestFixedbugs/issue60747.go (and parents). Expected error messages
("variable in assignment ... does not match inferred type") are no longer produced, and
mismatched-but-assignable parameter types are wrongly accepted by inference.
