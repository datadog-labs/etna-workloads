# Rationale

Fix (Go 1.16): in `wrapCall` (walk.go), turn `f(a, b, []T{c, d, e}...)` back into
`f(a, b, c, d, e)` before building the go/defer wrapper, so that the
unsafe.Pointer->uintptr special handling also sees variadic arguments.

In go1.27.3 the equivalent is `normalizeGoDeferCall` in
`src/cmd/compile/internal/typecheck/stmt.go`. Its `visit` closure recurses into the
elements of composite literals (including the OSLICELIT created by
`FixVariadicCall` for variadic args), so `uintptr(unsafe.Pointer)` conversions inside
the variadic slice are visited and the pointer is saved (the modern form of the fix).

Change: removed `ir.OSLICELIT` from the `case ir.OARRAYLIT, ir.OSLICELIT, ir.OSTRUCTLIT`
list. The variadic slice literal is then spilled whole into a temp, so the
conversions are not seen and escape's `rewriteArgument` (which looks for an OSLICELIT
argument) sees a closure variable instead, so the pointers are neither kept alive nor
escaped.

Oracle: `test/fixedbugs/issue24491a.go` fails with `panic: go: r[i] failed` (the
variadic `rest ...uintptr` pointer was finalized), the failure the fix's un-`break`ed
test guards against. `TestShouldTest` still passes.
