ATTACH ':memory:' AS db1;
CREATE TABLE db1.t(i INT);
CREATE VIEW db1.v AS SELECT * FROM db1.t;
SELECT sql FROM duckdb_views() WHERE database_name='db1';
