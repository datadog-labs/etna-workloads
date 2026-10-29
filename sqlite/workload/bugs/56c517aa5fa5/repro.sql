.connection 0
.open file:m?mode=memory&cache=shared
PRAGMA auto_vacuum=2;
CREATE TABLE t1(x,y);
WITH c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<128) INSERT INTO t1 SELECT randomblob(500),randomblob(500) FROM c;
.connection 1
.open file:m?mode=memory&cache=shared
SELECT count(*) FROM sqlite_master;
.connection 0
BEGIN;
DELETE FROM t1;
PRAGMA incremental_vacuum;
.connection 1
SELECT count(*) FROM sqlite_master;
.connection 0
COMMIT;
