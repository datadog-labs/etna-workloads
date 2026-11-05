create temp table t as select g empno from generate_series(1,5) g;
EXPLAIN (COSTS OFF)
SELECT * FROM (SELECT empno, count((SELECT 1)) OVER (ORDER BY empno DESC) c FROM t) e WHERE c = 1;
