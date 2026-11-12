.mode list
.nullvalue NULL
CREATE TABLE t0(c1 INTEGER[]);
INSERT INTO t0 VALUES ([1]);
SET debug_verify_column_bindings = true;
SELECT t0.c1 FROM t0, unnest(t0.c1) AS x(c0) WHERE CAST('x' AS BOOLEAN);
