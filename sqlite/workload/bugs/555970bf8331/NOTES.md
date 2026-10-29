`repro.sql` creates an index on the expression `+a COLLATE NOCASE`, then runs an aggregate query
whose argument `+a COLLATE NOCASE IN (SELECT 1)` is rewritten to TK_AGG_COLUMN (this is test case indexexpr2-10.1).
The buggy build no longer clears EP_Collate in that rewrite.

- clean: prints `4`, exit 0.
- buggy: aborts with an assertion failure in sqlite3ExprAffinity (`pExpr->op==TK_COLLATE ...`), exit -6.
