CREATE VIRTUAL TABLE ft USING fts5(a, contentless_delete=1, content='');
INSERT INTO ft(rowid, a) VALUES(1, 'A B');
INSERT INTO ft(rowid, a) VALUES(2, 'C C C C C C C C C C C C');
INSERT INTO ft(rowid, a) VALUES(3, 'C C C C C C C C C C C C');
INSERT INTO ft(rowid, a) VALUES(4, 'C');
INSERT INTO ft(rowid, a) VALUES(5, 'C');
DELETE FROM ft WHERE rowid=2;
DELETE FROM ft WHERE rowid=3;
SELECT rowid, bm25(ft) FROM ft('a');
