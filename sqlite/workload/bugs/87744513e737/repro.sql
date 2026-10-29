CREATE TABLE t(a,b);
CREATE INDEX i2 ON t(a,b);
CREATE INDEX i1 ON t(a,b) WHERE b=1;
INSERT INTO t VALUES(5,6);
PRAGMA integrity_check;
DELETE FROM t;
SELECT count(*) FROM t;
PRAGMA integrity_check;
