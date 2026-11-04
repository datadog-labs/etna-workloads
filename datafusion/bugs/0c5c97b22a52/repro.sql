SET datafusion.execution.target_partitions = 1;
CREATE TABLE stream_test (g INT, x DOUBLE, y DOUBLE) AS VALUES
(1, 1.0, 1.0), (1, 2.0, 2.0),
(2, 1.0, 5.0), (2, 2.0, 5.0),
(3, 1.0, 1.0), (3, 2.0, 2.0);
SELECT g, CORR(x, y) FROM (SELECT * FROM stream_test ORDER BY g LIMIT 10000) GROUP BY g ORDER BY g;
