# Rationale

Hunk reversed: `src/select.c`, `aggregateIdxEprRefToColCallback()`. The fix added
`ExprClearProperty(pExpr, EP_Skip|EP_Collate)` after the node is converted to
TK_AGG_COLUMN. In 3.54.1 the line also clears EP_Unlikely (added later, unrelated),
so I changed it to `ExprClearProperty(pExpr, EP_Unlikely)`, dropping only
EP_Skip|EP_Collate. The node is then TK_AGG_COLUMN with a stale EP_Collate, as before the fix.

Oracle: indexexpr2-10.1 fails with an assertion in sqlite3ExprAffinity
(`pExpr->op==TK_COLLATE || ...`). This is the assertion fault the forum posts
reported. The run aborts there, so later cases do not run.
