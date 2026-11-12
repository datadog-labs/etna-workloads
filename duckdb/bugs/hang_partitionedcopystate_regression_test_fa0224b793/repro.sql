SET partitioned_write_flush_threshold=100;
SET threads=4;
COPY (SELECT i%20 a, i b FROM range(200000) t(i) ORDER BY b DESC) TO 'repro_out' (FORMAT parquet, PARTITION_BY a, OVERWRITE_OR_IGNORE);
SELECT 'done';
