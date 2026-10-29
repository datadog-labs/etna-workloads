Reproducer (`repro.sql`): table t6(x,y) with rows (1,1),(0,0), a partial index
`i6 ON t6(x) WHERE y IS NOT TRUE`, then `SELECT * FROM t6 WHERE y IS TRUE ORDER BY x`.

Clean shell returns `1|1`. Buggy shell returns `0|0`, because sqlite3ExprCompare()
treats `y IS TRUE` as matching the index's `y IS NOT TRUE` WHERE clause, so the
query uses the partial index and returns the wrong row.
