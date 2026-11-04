SET datafusion.execution.target_partitions = 4;
CREATE TABLE t(c1 VARCHAR, c3 INT) AS VALUES ('a',1),('b',2),('c',3),('a',4);
SELECT c1, approx_percentile_cont(c3, 0.95, -1000) AS c3_p95 FROM t GROUP BY 1 ORDER BY 1;
