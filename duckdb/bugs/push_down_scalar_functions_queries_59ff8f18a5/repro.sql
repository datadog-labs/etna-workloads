CREATE VIEW pe AS SELECT str_val FROM 'data/parquet-testing/varchar_stats.parquet';
EXPLAIN SELECT strlen(str_val) FROM pe LIMIT 1;
