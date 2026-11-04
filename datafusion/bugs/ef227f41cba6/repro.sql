SET datafusion.execution.target_partitions = 4;
CREATE TABLE t AS SELECT * FROM (VALUES (1),(NULL),(3),(4),(5),(NULL)) AS v(value);
SELECT value, min(value) FROM t GROUP BY CUBE(value) ORDER BY value, 2;
SELECT value, count(*) FROM t GROUP BY ROLLUP(value) ORDER BY value, 2;
