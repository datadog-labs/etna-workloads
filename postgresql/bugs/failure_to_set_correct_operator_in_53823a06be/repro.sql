create table t as select g a from generate_series(1,5) g;
EXPLAIN (COSTS OFF)
SELECT * FROM (SELECT a, count(a) OVER () c FROM t) s WHERE c = 1;
SELECT * FROM (SELECT a, count(a) OVER () c FROM t) s WHERE c = 1;
