repro.sql creates a view `v15 AS SELECT a AS x, b AS y FROM t1` and runs `SELECT x, y FROM v15 LIMIT 1` with headers on.
Clean shell prints column names `x|y`; the buggy shell prints `a|b`, because the flattener names the outer columns after substitution instead of before it.
