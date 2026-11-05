CREATE TABLE tabx(id int primary key);
INSERT INTO tabx SELECT generate_series(1,100);
VACUUM tabx;
SET enable_seqscan=off;
SET enable_bitmapscan=off;
BEGIN ISOLATION LEVEL SERIALIZABLE;
EXPLAIN (costs off) SELECT id FROM tabx WHERE id < 5;
SELECT id FROM tabx WHERE id < 5;
SELECT l.locktype, c.relname FROM pg_locks l JOIN pg_class c ON c.oid=l.relation
 WHERE l.mode='SIReadLock' AND c.relname='tabx' ORDER BY 1;
COMMIT;
