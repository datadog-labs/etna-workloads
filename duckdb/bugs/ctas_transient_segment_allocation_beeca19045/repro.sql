SET initial_column_segment_size = 2048;
CREATE TABLE t AS SELECT range::FLOAT AS value FROM range(1_000_000);
SELECT memory_usage_bytes < 8_000_000 FROM duckdb_memory() WHERE tag = 'IN_MEMORY_TABLE';
