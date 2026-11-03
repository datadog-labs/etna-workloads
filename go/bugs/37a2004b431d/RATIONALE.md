# Rationale

Changed `src/cmd/compile/internal/noder/reader.go` (method-value wrapper handling in `reader.expr`).

The fix replaced `assert(n.Selection == wrapperFn.Selection)` with a relaxed check that falls back to comparing Sym and Type when the `types.Field` pointers differ (anonymous receiver types can have separate Field instances, #58563). I reverted that block to the original strict pointer-equality assertion. The surrounding code now uses `typecheck.XDotMethod`, but the check is otherwise the same as before the fix.

Oracle: `test/fixedbugs/issue58563.go` fails with `a.go:7:6: internal compiler error: assertion failed`. This is the spurious assertion failure the fix addressed. `TestShouldTest` still passes.
