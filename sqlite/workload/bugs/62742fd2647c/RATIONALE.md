# Rationale

Fix hunk reversed: in `selectWindowRewriteExprCb()` (src/window.c), the fix added
`pExpr->y.pTab = p->pTab;` so that expressions rewritten into TK_COLUMN references
to the window sub-select's ephemeral table carry that table (giving them the right
collation sequence and affinity). Most of the rest of the fix (WindowRewrite.pTab,
the pTab parameter, the pTab/pTab2 handling in sqlite3WindowRewrite) is still present in 3.54.1,
so I removed only the `pExpr->y.pTab = p->pTab;` line. The rewritten TK_COLUMN
expression then has a NULL y.pTab, which is the pre-fix state (no table, so no
column affinity/collation lookup).

(The select.c hunk only removed an assert; nothing to revert.)

Oracle: with the line removed, 40 of 42 window9 cases fail. The testfixture hits
`Assertion pExpr->y.pTab!=0` in sqlite3ExprCodeTarget at the first window query (1.2),
and the following cases are not run (the process aborts). In a non-assert build the result
would be lost collations/affinities (e.g. dense_rank over NOCASE columns).
