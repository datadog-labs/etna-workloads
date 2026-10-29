CREATE TABLE t1(log int);
SELECT log, count(*) FROM t1 GROUP BY ORDER BY log;
SELECT log, count(*) FROM t1 GROUP BY;
