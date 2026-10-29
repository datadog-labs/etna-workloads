CREATE VIRTUAL TABLE ft1 USING fts5(a, detail=none);
INSERT INTO ft1(ft1, rank) VALUES('secure-delete', 1);
INSERT INTO ft1(ft1, rank) VALUES('pgsz', 64);
WITH s(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<500)
INSERT INTO ft1 SELECT 'abcdefg' FROM s;
DELETE FROM ft1 WHERE rowid>=250;
DELETE FROM ft1 WHERE rowid>=100;
INSERT INTO ft1(ft1) VALUES('integrity-check');
