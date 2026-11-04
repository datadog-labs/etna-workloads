COPY (SELECT * FROM (VALUES (1, 16777217), (2, 16777216)) AS t(k, v)) TO 'data.csv' STORED AS CSV OPTIONS ('format.has_header' 'true');

CREATE EXTERNAL TABLE t1 (k int, v int)
STORED AS CSV
WITH ORDER (v DESC, k DESC)
LOCATION 'data.csv'
OPTIONS ('format.has_header' 'true');

SELECT k, cast(v as float) v_ FROM t1 ORDER BY v_ DESC, k DESC;
EXPLAIN SELECT k, cast(v as float) v_ FROM t1 ORDER BY v_ DESC, k DESC;
