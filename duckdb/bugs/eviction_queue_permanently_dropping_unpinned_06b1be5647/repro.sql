.bail off
SET temp_directory = '';
SET max_memory = '80MB';
SET threads = 1;
CREATE TABLE t AS SELECT range::INT AS a, repeat('y', 80000) AS s FROM range(400);
SET max_memory = '10MB';
SET temp_directory = 'evict_tmp.tmp';
SET max_memory = '10MB';
SELECT sum(memory_usage_bytes) <= 10000000 FROM duckdb_memory();
