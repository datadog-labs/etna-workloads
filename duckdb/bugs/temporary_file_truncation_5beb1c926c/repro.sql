SET threads = 1;
SET memory_limit = '24MiB';
SET preserve_insertion_order = false;
CREATE TEMPORARY TABLE t AS SELECT i, repeat('t', 80)::VARCHAR AS s FROM range(500000) t(i);
CREATE TEMPORARY TABLE tail AS SELECT i, md5(i::VARCHAR) AS x FROM range(1000000) t(i) ORDER BY x;
DROP TABLE tail;
SET memory_limit = '1GB';
SELECT (SELECT coalesce(sum(size), 0)::BIGINT FROM duckdb_temporary_files())
     = (SELECT coalesce(sum(size), 0)::BIGINT FROM read_blob('.tmp/*.tmp'));
