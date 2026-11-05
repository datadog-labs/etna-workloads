CREATE TABLE tidscan(id integer);
INSERT INTO tidscan VALUES (1),(2);
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM tidscan WHERE ctid = '(0,1)';
SELECT locktype, mode FROM pg_locks WHERE mode = 'SIReadLock';
ROLLBACK;
