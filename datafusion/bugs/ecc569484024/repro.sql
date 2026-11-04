SET datafusion.execution.target_partitions = 1;
COPY (values (1), (2), (3), (4), (5)) TO 't1.csv' STORED AS CSV;
COPY (values (5), (4), (3), (2), (1)) TO 't2.csv' STORED AS CSV;
CREATE EXTERNAL TABLE t1(a int) STORED AS CSV LOCATION 't1.csv';
CREATE EXTERNAL TABLE t2(b int) STORED AS CSV LOCATION 't2.csv';
SELECT * FROM t1 FULL JOIN t2 ON t1.a = t2.b LIMIT 2;
EXPLAIN SELECT * FROM t1 FULL JOIN t2 ON t1.a = t2.b LIMIT 2;
