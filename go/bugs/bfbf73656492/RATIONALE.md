# issue 71184: reshaping an expression re-shapifies its type arguments

## Why the fix hunks cannot be reversed
The fix's `reshaping` flags (pkgReader/reader, objDictIdx, exprReshape, funcInst) are
not in go1.27.3, and the test still passes without them. A separate mechanism now covers
the case: `exprReshape` marks a reshaped `*ir.CallExpr` with `call.Reshape = true`.
That makes inlining (`ir/expr.go`) and SSA gen (`ssagen/ssa.go`) convert the call
result from the callee's shape result type (`go.shape.*uint8`) to the expression's
real type (`*[0]go.shape.int32`).

## Change
`src/cmd/compile/internal/noder/reader.go`, `exprReshape`: dropped
`call.Reshape = true`. No other file changed.

This is the same defect the fix addressed. `G[*[0]T]` is instantiated with its type
argument shapified to `go.shape.*uint8`, so the call expression keeps a pointer shape
type instead of `*[0]go.shape.int32`. The fix avoided this by not shapifying while
reshaping. Dropping `Reshape` removes the compensating conversion and leaves the
unconverted shape type, as before the fix.

## Oracle
`test/fixedbugs/issue71184.go` fails at compile time with
`internal compiler error: 'F[int32]': bad ptr to array in slice go.shape.*uint8`.
This is the error the upstream issue reported. `TestShouldTest` passes.
