PRAGMA locking_mode=EXCLUSIVE;
BEGIN;
ATTACH 'file:/one?vfs=memdb' AS aux1;
ATTACH 'file:/one?vfs=memdb' AS aux2;
CREATE VIRTUAL TABLE t1 USING fts5(x);
ANALYZE;
COMMIT;
COMMIT;
ROLLBACK;
