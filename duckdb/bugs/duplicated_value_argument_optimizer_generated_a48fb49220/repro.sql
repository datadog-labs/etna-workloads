.mode list
.nullvalue NULL
CREATE TABLE t(x INTEGER);
EXPLAIN SELECT count(*) FROM t WHERE x * 0 = 1;
