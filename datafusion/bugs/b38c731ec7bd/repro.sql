COPY (SELECT arrow_cast(1, 'Int8') AS a, arrow_cast(2.5, 'Float64') AS b, 'x' AS c)
TO 'out_part/' STORED AS parquet PARTITIONED BY (a, b);

CREATE EXTERNAL TABLE t (a int, b double, c varchar) STORED AS PARQUET
LOCATION 'out_part/' PARTITIONED BY (a, b);

SELECT a, b, c FROM t ORDER BY a;
