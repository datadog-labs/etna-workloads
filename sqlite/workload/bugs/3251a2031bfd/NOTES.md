Reproducer (repro.sql): the colname-9.330 query on a 5-row table t1(a).
`SELECT (SELECT avg(a) UNION SELECT min(a) OVER() ORDER BY 1) FROM t1;`

Clean shell prints `17`. Buggy shell aborts with
`Assertion 'pColExpr->op!=TK_AGG_COLUMN' failed` in sqlite3ColumnsFromExprList
(exit status -6), because the injection restores the incorrect asserts.
