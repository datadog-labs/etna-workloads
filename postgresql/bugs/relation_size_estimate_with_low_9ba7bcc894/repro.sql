CREATE TABLE tf (n char(1000)) WITH (fillfactor=10, autovacuum_enabled=off);
INSERT INTO tf SELECT 'x' FROM generate_series(1,1000);
EXPLAIN SELECT * FROM tf;
