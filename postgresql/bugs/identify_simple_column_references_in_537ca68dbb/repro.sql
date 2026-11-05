CREATE TABLE t (x int, y int);
CREATE STATISTICS tst ON (y) FROM t;
SELECT count(*) FROM pg_statistic_ext;
