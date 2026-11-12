SET VARIABLE p = 64;
COPY (SELECT 42 i, getvariable('p') AS p) TO 'data' (FORMAT parquet, PARTITION_BY p);
