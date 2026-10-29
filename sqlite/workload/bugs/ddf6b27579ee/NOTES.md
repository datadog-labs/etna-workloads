Reproducer (repro.sql): the window1-77 case. A table has an index on `likely(x)`, and an aggregate query with FILTER uses that index via INDEXED BY: `SELECT max(~likely(x)) FILTER (WHERE true) FROM t1 INDEXED BY t1x GROUP BY x`.

Clean shell: prints -2, -3, -5, -9.
Buggy shell: aborts on assertion `pExpr->op==TK_FUNCTION` in sqlite3ExprSkipCollateAndLikely (exit -6). The cause is that EP_Unlikely stays set after the expression is converted to TK_AGG_COLUMN.
