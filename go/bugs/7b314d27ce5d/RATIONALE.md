# Rationale

The fix (issue 50672) made `f()(g())` with multi-value `g` evaluate `f()` before `g()`
by calling `typecheck.RewriteNonNameCall` (hoisting the callee into a temp) from `tcCall`
(and the old noder `transformCall`, which no longer exists).

In go1.27.3 the unified-IR reader (`noder/reader.go`, `multiExpr`) already lowers `g()`
into temporaries carried as init on the first argument. Simply dropping the
`RewriteNonNameCall` call in `tcCall` does not reproduce the bug, and it crashes the inliner
(`CalleeEffects` needs the rewrite). So the pre-fix ordering is restored this way:

- `typecheck/func.go` `tcCall`: before `RewriteNonNameCall(n)`, move the first argument's
  init (the multi-value call's `t1, t2 := g()`) into the call's init. The callee temp
  assignment is appended after it, giving `t1, t2 := g(); t0 := f(); t0(t1, t2)`, the
  pre-fix order from the commit message. The pre-fix `typecheckargs` had the same effect.

The other fix hunks (callOrChan refactor, comment, transform.go call) don't affect behavior and
were left alone.

Oracle: `test/fixedbugs/issue50672.go` fails with `panic: FAIL` from `g` in the
package-level `var _ = f()(g())` initialization (g runs before f sets `ok`).
