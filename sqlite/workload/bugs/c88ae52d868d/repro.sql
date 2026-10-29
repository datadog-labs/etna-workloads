PRAGMA temp.page_size=1024;
PRAGMA temp.cache_size=50;
BEGIN;
CREATE TEMP TABLE t1(a INTEGER PRIMARY KEY, b);
INSERT INTO t1 VALUES(1, substr(replace(hex(zeroblob(450)),'00','1.'),1,900));
INSERT INTO t1 VALUES(2, substr(replace(hex(zeroblob(450)),'00','1.'),1,900));
INSERT INTO t1 VALUES(3, substr(replace(hex(zeroblob(450)),'00','1.'),1,900));
CREATE TEMP TABLE t2(a INTEGER PRIMARY KEY, b);
WITH c(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM c WHERE x<100)
INSERT INTO t2 SELECT x, substr(replace(hex(zeroblob(450)),'00',x||'.'),1,900) FROM c;
COMMIT;
UPDATE t1 SET b=substr(replace(hex(zeroblob(450)),'00','2.'),1,900);
SELECT b=substr(replace(hex(zeroblob(450)),'00','2.'),1,900) FROM t1;
BEGIN;
DELETE FROM t1;
UPDATE t2 SET b=substr(replace(hex(zeroblob(450)),'00',(a+1)||'.'),1,900);
ROLLBACK;
SELECT b=substr(replace(hex(zeroblob(450)),'00','2.'),1,900) FROM t1;
