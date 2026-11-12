COPY (SELECT CASE WHEN i<2048 THEN '07' ELSE '08' END AS day, i::INTEGER i FROM range(4096) t(i)) TO '__p' (FORMAT parquet, PARTITION_BY day, ROW_GROUP_SIZE_BYTES 16384, OVERWRITE);
SELECT day, count(*) FROM read_parquet('__p/**/*.parquet', hive_partitioning=true) GROUP BY ALL ORDER BY ALL;
