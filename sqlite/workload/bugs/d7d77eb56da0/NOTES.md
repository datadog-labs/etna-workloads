repro.sql: table t1(c1 TEXT, c2 INTEGER, PRIMARY KEY(c1,c2)) with row ('a',1); runs
`SELECT (1,'a') IN (SELECT c2,c1 FROM t1)`, where the row-value columns must be reordered to match the index.
Clean shell prints 1; buggy shell prints 0, because affinity is applied after the reordering (wrong affinity per column).
