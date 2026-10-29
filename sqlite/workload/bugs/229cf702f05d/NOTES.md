Reproducer (repro.sql): builds the tkt3334 table t1 and runs
`SELECT a FROM (SELECT a FROM t1 ORDER BY b LIMIT 2) WHERE a=1;`.
Clean shell returns no rows (the two smallest-b rows have a=4,2). The buggy
shell lacks flattener restriction (19), flattens the LIMIT subquery into the
outer WHERE, and returns wrong rows (two rows of `1`).
