repro.sql: table t1 with a partial index `WHERE a>NULL`, then `SELECT * FROM t1 WHERE a IS NOT NULL`.
Clean shell returns the row `10|10`. Buggy shell wrongly uses the partial index
(missing TERM_VNULL check in where.c), which is empty, so no rows are returned.
