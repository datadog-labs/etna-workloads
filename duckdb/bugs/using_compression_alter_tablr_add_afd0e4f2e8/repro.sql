CREATE TABLE t(i INTEGER);
ALTER TABLE t ADD COLUMN j INTEGER USING COMPRESSION Uncompressed;
SELECT contains(sql, 'USING COMPRESSION Uncompressed') FROM duckdb_tables() WHERE table_name='t';
