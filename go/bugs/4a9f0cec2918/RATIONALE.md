# Rationale

Bug (issue 47928): irgen built method sets / promoted-method copies before the
`//go:nointerface` pragma was recorded on the embedded type's methods, so a
promoted method (`T` embeds `U`, `(*U).Bad` is nointerface) lost its
nointerface status and ended up in T's runtime method table, making
`i.(interface{ Bad() })` succeed.

irgen's ordering (the fix's `later`/`exprStmtOK` hunks in decl.go, irgen.go,
stmt.go, expr.go) no longer exists: unified IR sets the flag in
`reader.go` when the method is read. The equivalent defect is the promoted
copy not carrying the pragma.

Changed: `src/cmd/compile/internal/typecheck/subr.go`, `CalcMethods`: after
`f = f.Copy()` for a promoted method, `f.SetNointerface(false)`. The promoted
method thus behaves as if the pragma was not yet visible when it was copied,
the observable effect of the pre-fix ordering.

Oracle: `test/fixedbugs/issue47928.go` fails with `panic: FAIL` (the type
assertion to `interface{ Bad() }` succeeds). `TestShouldTest` passes.
