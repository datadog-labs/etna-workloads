SET threads=2;
SET memory_limit='60MB';
SET temp_directory='duckdb_tmp_repro';
CREATE TABLE t AS SELECT range a FROM range(3000000);
CREATE TABLE u AS SELECT range b FROM range(3000000);
SELECT count(*) FROM t WHERE a IN (SELECT b FROM u);
