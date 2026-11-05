CREATE EXTENSION pg_walinspect;
CREATE TABLE t(a int) WITH (autovacuum_enabled=off);
INSERT INTO t VALUES (1);
VACUUM t;
CHECKPOINT;
SELECT pg_current_wal_insert_lsn() AS l \gset
INSERT INTO t VALUES (2);
SELECT count(*) FILTER (WHERE relforknumber=2) AS vm_blocks_in_insert
FROM pg_get_wal_block_info(:'l', pg_current_wal_insert_lsn()) b
JOIN pg_get_wal_records_info(:'l', pg_current_wal_insert_lsn()) r USING (start_lsn)
WHERE r.resource_manager='Heap';
