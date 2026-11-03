# Rationale

Fix hunk reversed: types2/expr.go, `opPos` (the fix's new helper that replaced the
inline `pos := syntax.StartPos(x.expr)` in `overflow`). The fix's `case nil: return nopos // don't crash`
is removed, so a nil `x.expr` falls to `syntax.StartPos(nil)` and panics, as before the fix.
In go1.27.3 the position computation lives in the callers (`check.overflow(x, opPos(x.expr))`),
so removing the nil case restores the crash.

Oracle: TestFixedbugs/issue52401.go (`x += 1` / `x++` on a constant, where x.expr is nil) panics
with a nil dereference in the type checker; since the panic aborts the package test run,
many other types2 oracle cases fail too.
