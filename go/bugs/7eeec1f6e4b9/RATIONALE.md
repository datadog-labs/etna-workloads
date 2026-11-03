# Rationale

The fix (issue 53309) changed `dictPass` in stencil.go so that a type assertion becomes
dynamic if either the destination type or the source type has shape. Before it, only the
destination type was checked. stencil.go no longer exists in go1.27.3. Unified IR makes
the same decision in `reader.exprType` (src/cmd/compile/internal/noder/reader.go).

## Change
In the non-empty-interface branch of `reader.exprType`, I added an early return of a
static `ir.TypeNode(typ)` when the destination type `typ` has no shape. This restores the
old condition, which looked only at the destination type and ignored whether the source
interface had shape. In the issue's test, `v.(*taskResult)` has a shaped source,
`Value[T]`, and a non-shaped destination, so it is now compiled as a static assertion.
That compares against the wrong itab.

## Oracle
`test/fixedbugs/issue53309.go` fails with `panic: output must be *taskResult`. This is
the failure the fix's test guards against. `TestShouldTest` passes.
