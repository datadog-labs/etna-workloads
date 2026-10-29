repro.sql: builds t1(c1 UNIQUE NOT NULL) with one row and t0(c0 UNIQUE) with one 0 plus 1000 NULLs, runs ANALYZE, then runs `SELECT DISTINCT * FROM t1 LEFT OUTER JOIN t0 ON c0>c1`.

Clean shell prints `1|`. The buggy shell prints `1|` and then a spurious `1|0`. The DISTINCT skip-ahead code in sqlite3WhereEnd reads the index columns of the right-hand table even when that cursor is on the LEFT JOIN null row. Without the OP_IfNullRow guard, it seeks using the wrong values.
