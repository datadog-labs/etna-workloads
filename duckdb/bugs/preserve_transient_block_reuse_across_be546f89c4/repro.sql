ATTACH ':memory:' AS t;
SET threads = 2;
SET preserve_insertion_order = false;
SET memory_limit = '16MB';
SET temp_directory = '';
SET initial_column_segment_size = 2048;
CREATE TABLE t.x AS SELECT (i % 127)::TINYINT AS value FROM range(10_000_000) r(i);
SELECT COUNT(*), SUM(value) FROM t.x;
