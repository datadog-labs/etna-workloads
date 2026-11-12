SET threads=16;
SET memory_limit='120MB';
SELECT count(*) FROM (SELECT * FROM read_parquet(['data/parquet-testing/uuid_v2.parquet' for i in range(100)]) ORDER BY ALL OFFSET 100000000);
