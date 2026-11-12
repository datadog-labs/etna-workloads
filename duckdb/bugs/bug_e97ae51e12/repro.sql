SET disabled_optimizers='filter_pushdown';
CREATE TABLE t AS SELECT i, 'a long string value number ' || (i%7) AS s FROM range(3000) r(i);
SELECT * FROM t t1, t t2 WHERE t1.i=t2.i ORDER BY t1.s LIMIT 0;
