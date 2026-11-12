SET debug_force_fetch_row = true;
CREATE TABLE t AS SELECT i, repeat('x', 100) || i AS s FROM range(100000) r(i);
SELECT count(*), max(s) FROM t WHERE i BETWEEN 60000 AND 60010;
