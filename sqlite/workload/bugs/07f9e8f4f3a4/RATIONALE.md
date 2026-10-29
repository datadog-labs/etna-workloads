# Rationale

Fix: `substExpr()` in select.c wraps a substituted view/subquery column in a
TK_IF_NULL_ROW node (LEFT JOIN rhs) and the fix marks it `EP_Skip` so that
`sqlite3ExprAffinity()` looks through it to the wrapped column's affinity.
Without it the wrapper has no affinity and the column's affinity is discarded.

In 3.54.1 this was redesigned: the wrapper is flagged `EP_IfNullRow` and
`sqlite3ExprAffinity()` (src/expr.c) skips on `EP_Skip|EP_IfNullRow`.

Change (src/expr.c, sqlite3ExprAffinity): the skip condition is back to
`EP_Skip` only (and the assert drops TK_IF_NULL_ROW). This reverses the
fix hunk that added `ifNullRow.flags = EP_Skip` (the select.c hunk); the
TK_IF_NULL_ROW node again contributes no affinity. The expr.c assert hunks
are subsumed. EP_IfNullRow itself is still set (used in whereexpr.c).

Oracle failures: join2-9.4 and join2-9.5 return `0 {}` instead of `0 0`
(the comparison `v0.c0 >= '0'` is done without INTEGER affinity applied to the view column).
