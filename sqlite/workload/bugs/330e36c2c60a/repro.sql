CREATE VIRTUAL TABLE ft USING fts5(x, content=, contentless_delete=1);
INSERT INTO ft(ft, rank) VALUES('pgsz', 64);
WITH s(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<1000)
INSERT INTO ft(rowid, x) SELECT i, i||' '||i||' '||i||' '||i FROM s;
INSERT INTO ft(ft) VALUES('optimize');
DELETE FROM ft WHERE (rowid % 50)==0;
INSERT INTO ft(ft, rank) VALUES('merge', 500);
INSERT INTO ft(ft, rank) VALUES('merge', -1000);
SELECT count(*) FROM ft_data;
DELETE FROM ft WHERE (rowid % 50)==1;
SELECT count(*) FROM ft_data;
INSERT INTO ft(ft, rank) VALUES('merge', -5);
INSERT INTO ft(ft, rank) VALUES('merge', -5);
INSERT INTO ft(ft, rank) VALUES('merge', -5);
INSERT INTO ft(ft, rank) VALUES('merge', -5);
INSERT INTO ft(ft, rank) VALUES('merge', -5);
INSERT INTO ft(ft, rank) VALUES('merge', -5);
