SET datafusion.execution.target_partitions = 4;
COPY (SELECT * FROM (VALUES (1, 1), (2, 3), (200, 10), (255, 10)) AS t(a, b) ORDER BY a)
TO 'uint8_overflow.csv' OPTIONS ('format.has_header' 'false');
CREATE EXTERNAL TABLE ordered_u8 (a TINYINT UNSIGNED NOT NULL, b TINYINT UNSIGNED NOT NULL)
STORED AS CSV LOCATION 'uint8_overflow.csv' OPTIONS ('format.has_header' 'false')
WITH ORDER (a ASC) WITH ORDER (b ASC);
SELECT (a + b) AS result FROM ordered_u8 ORDER BY result ASC;
EXPLAIN SELECT (a + b) AS result FROM ordered_u8 ORDER BY result ASC;
