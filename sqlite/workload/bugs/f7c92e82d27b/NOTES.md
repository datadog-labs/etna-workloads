repro.sql: table with PRIMARY KEY (c0,c1), 11 rows with c0 NULL and c2 NULL plus one with c2='a', then ANALYZE,
then `SELECT DISTINCT * FROM t0 WHERE NULL IS c0`.
Clean shell returns 2 rows (`|1|` and `|1|a`). Buggy shell returns only `|1|`: with the injected
change, an `IS` constraint on a NULL-able index column is wrongly treated as keeping the index
order distinct, so the DISTINCT handling is wrong and the row `|1|a` is lost.
