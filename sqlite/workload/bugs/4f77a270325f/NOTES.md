repro.sql: table t1 with an index on CAST((c0 IS TRUE) AS TEXT), plus a view v0 with the same expression. It queries `t1, v0 WHERE 0 < LIKELY(v0.c2)`.
Clean shell returns the row `NULL|'0'`. Buggy shell returns no rows, because sqlite3ExprCompareSkip() wrongly skips LIKELY() and matches the expression against the index.
