Reproducer (`repro.sql`): a window-function query that also selects a column expression (`c=='Abc'`, `b=='2'`) from a table with a NOCASE collation or a BLOB column.

Without the fix, `sqlite3WindowRewrite` doesn't set `y.pTab` on the rewritten column references.
- Clean shell: prints `1|1`, `1|2`, `1|1`, `0|2`.
- Buggy shell: aborts with the assertion `pExpr->y.pTab!=0` in `sqlite3ExprCodeTarget` (exit status -6).
