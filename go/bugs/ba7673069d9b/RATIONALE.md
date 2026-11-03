# Rationale

Fix (golang/go#48598): calls of explicitly instantiated generic functions, `F[T](args)`,
lost the implicit CONVIFACE conversions of their arguments, because the
OFUNCINST call path skipped the transformation that exposes them
(the fix added `transformEarlyCall` -> `typecheckaste`). stencil.go/transform.go
no longer exist in go1.27.3 (unified IR); implicit argument conversions are now
written by the unified IR writer in `multiExpr` via the `paramType` callback.

Change (src/cmd/compile/internal/noder/writer.go, `exprCall` case): when `expr.Fun`
is an `*syntax.IndexExpr` (explicit instantiation), `paramType` returns nil, so
`multiExpr`/`implicitConvExpr` emit no implicit conversion of the arguments to the
parameter types. This restores the pre-fix behaviour: arguments of a call with an
explicit instantiation are not converted to interface parameter types.

Oracle: `test/typeparam/issue48598.go` fails
(`FromIterator[R](IteratorFunc[R](nil))` -> "internal compiler error: incomplete itab").
`TestShouldTest` passes.
