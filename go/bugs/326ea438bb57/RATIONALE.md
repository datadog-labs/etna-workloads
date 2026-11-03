# Rationale (issue 46725)

The fix rewrote `a, b = f()` to use autotemps when an LHS type is not identical to the
call's result type (typecheck/stmt.go `assign` + `RewriteMultiValueCall`'s AssignListStmt case).
In go1.27.3 that typecheck path is dead for gc (unified IR does it in noder), so reverting it alone changes nothing.

Changes:
1. `typecheck/stmt.go` (`assign`, OAS2FUNC case): restored the pre-fix loop (just `assignType`), dropping the
   `mismatched`/`failed` tracking and the `RewriteMultiValueCall` call. Reverses the stmt.go hunk.
   (The `RewriteMultiValueCall` AssignListStmt case, the typecheck.go hunk, is left; it is now unreachable.)
2. `noder/reader.go`: `multiExpr` is now `multiExprCall(direct)`. For an assignment statement whose N:1 RHS
   call has results needing implicit conversion to the LHS types, the unified-IR reader no longer
   desugars into temps and returns the bare call (OAS2 -> OAS2FUNC via typecheck), as pre-fix typecheck did.
   This is the unified-IR equivalent of the fix's rewrite and is the same defect.
   Escape analysis then sees OAS2FUNC with mismatched LHS (`e.addrs(n.Lhs)`, `e.call(ks, ...)`) and mishandles the conversion.

Oracle: `test/fixedbugs/issue46725.go` fails with `panic: GC'd early` (the value converted to interface
is not kept alive; memory corruption). `declbad.go` still passes (its regexp accepts both error forms).
