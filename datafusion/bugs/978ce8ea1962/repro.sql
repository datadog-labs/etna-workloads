SET datafusion.execution.target_partitions = 4;
SET datafusion.explain.format = 'tree';
CREATE TABLE src AS SELECT * FROM (VALUES (1,'a'),(2,'b'),(3,'c'),(4,'d')) AS v(x,y);
COPY (SELECT * FROM src) TO 'dir/a.csv';
COPY (SELECT * FROM src) TO 'dir/b.csv';
CREATE EXTERNAL TABLE t (x INT, y VARCHAR) STORED AS CSV LOCATION 'dir/';
EXPLAIN SELECT * FROM t ORDER BY x, y LIMIT 5;
