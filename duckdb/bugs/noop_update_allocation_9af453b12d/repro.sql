CREATE TABLE t AS SELECT repeat('x', 4000000) AS payload;
CHECKPOINT;
UPDATE t SET payload = payload;
SELECT memory_usage_bytes < 2000000 FROM duckdb_memory() WHERE tag = 'ALLOCATOR';
