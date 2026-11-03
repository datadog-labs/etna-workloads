# Rationale

Fix (#48049): generic code lacked the CONVIFACE for assignments such as
`mr.r[0] = fooer1[T]{}` (concrete generic type -> interface element); the fix added
`earlyTransformAssign` in noder/stmt.go and transform.go (both gone in 1.27.3, since the
unified IR writer inserts implicit conversions).

Change: `src/cmd/compile/internal/noder/writer.go`, `assignStmt`'s `dstType` closure.
For N:N assignments to a non-name destination (index/field/deref), when the RHS type is
derived (mentions type parameters) but is not itself a type parameter, no destination
type is reported, so `multiExpr`/`implicitConvExpr` omits the implicit conversion.
This reverses the fix's effect (the interface conversion on generic assignments,
`rhs[i] = assignconvfn(r, lhs[i].Type())`). Type-parameter sources are excluded so the
standard library (e.g. fips140/hmac) still builds.

Oracle: `test/typeparam/issue48049.go` fails with
`internal compiler error: incomplete itab` at the assignment `mr.r[0] = fooer1[T]{}`.
(TestShouldTest passes.)
