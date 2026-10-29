# Rationale

## Changed hunk
`tree/src/whereexpr.c`, `exprMightBeIndexed2()`: the condition
`!sqlite3ExprIsConstant(0,pIdx->aColExpr->a[i].pExpr)` is replaced by the
pre-fix `pExpr->op!=TK_STRING`.

This reverses the only implementation hunk of the fix (src/whereexpr.c in
fix.patch). The fix swapped the TK_STRING test for a check that the indexed
expression is not constant. The current tree has only the call signature
changed (extra `pParse` argument), so the revert is a direct restoration of
the old test. Without it, an index on a constant expression such as
`CREATE INDEX i0 ON t1(NULL)` is treated as possibly useful for comparisons
like `c3<NULL`, and the planner is misled.

## Oracle failures
`whereL-810` fails (the `WHERE c2/0.1` query returns a wrong result).
Other whereL cases still pass.
