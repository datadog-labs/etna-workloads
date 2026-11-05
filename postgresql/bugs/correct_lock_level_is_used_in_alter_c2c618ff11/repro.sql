CREATE TABLE rt (a INT);
BEGIN;
ALTER INDEX rt RENAME TO rt2;
SELECT relation::regclass, mode FROM pg_locks
WHERE locktype = 'relation' AND relation = 'rt2'::regclass;
COMMIT;
