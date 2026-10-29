PRAGMA page_size=1024;
CREATE VIRTUAL TABLE t1 USING fts5(x);
WITH s(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<5000)
INSERT INTO t1(rowid, x) SELECT i, (i/2)*2 FROM s;
BEGIN;
WITH s(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<5000)
INSERT INTO t1(x) SELECT i FROM s WHERE i%2;
DELETE FROM t1 WHERE rowid<=5000 AND rowid%2=0;
COMMIT;
INSERT INTO t1(t1, rank) VALUES('usermerge', 2);
INSERT INTO t1(t1, rank) VALUES('merge', 1);
INSERT INTO t1(t1) VALUES('integrity-check');
INSERT INTO t1(t1, rank) VALUES('merge', 1);
INSERT INTO t1(t1) VALUES('integrity-check');
INSERT INTO t1(t1, rank) VALUES('merge', 1);
INSERT INTO t1(t1) VALUES('integrity-check');
INSERT INTO t1(t1, rank) VALUES('merge', 1);
INSERT INTO t1(t1) VALUES('integrity-check');
INSERT INTO t1(t1, rank) VALUES('merge', 1);
INSERT INTO t1(t1) VALUES('integrity-check');
