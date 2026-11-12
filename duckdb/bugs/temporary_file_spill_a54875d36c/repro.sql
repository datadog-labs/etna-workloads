.bail off
PRAGMA memory_limit='8MB';
SET max_temp_directory_size='0B';
CREATE TABLE t AS SELECT repeat('x', 300000)::VARCHAR s, i FROM range(200) tbl(i);
SELECT count(*) FROM duckdb_memory() WHERE temporary_storage_bytes > 0;
