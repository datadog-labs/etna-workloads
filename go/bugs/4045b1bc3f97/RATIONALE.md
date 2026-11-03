# Rationale

The fix (#53406) corrected an over-strict assertion in the old stencil.go
(`assert(usingSubdict)` for every generic method call). The stencil code no
longer exists in go1.27.3; its analogue is `writer.methodExpr` in
noder/writer.go, which picks a dynamic subdictionary (receiver type args
derived from the enclosing function's type params) or a static dictionary
(receiver already fully instantiated, e.g. the promoted `Inner[int].M`).

Change: in the static-dictionary branch, re-add an assertion that this case
cannot occur inside a function that has derived types (i.e. a generic function),
as the pre-fix code asserted a subdictionary must be used. The fix's
`assert(!usingSubdict)` for non-shaped targs is the removed handling; the
static branch is exactly that case.

Oracle: test/typeparam/issue53406.go fails: `f[T1]` calls `x.M()` where
x is `Outer[T1,int]` embedding `Inner[int]`, so the call is static, but f has
derived types, tripping the assertion (compiler crash).
