SET datafusion.execution.target_partitions = 4;
SELECT COUNT(*) FROM (SELECT SUM(v1) FROM generate_series(10) AS t1(v1) WHERE false GROUP BY ROLLUP(v1));
SELECT COUNT(*) FROM (SELECT SUM(v1) FROM generate_series(10) AS t1(v1) WHERE false GROUP BY CUBE(v1));
SELECT COUNT(*) FROM (SELECT SUM(v1) FROM generate_series(10) AS t1(v1) WHERE false GROUP BY GROUPING SETS((v1), (), ()));
