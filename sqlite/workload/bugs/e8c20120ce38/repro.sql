CREATE VIRTUAL TABLE f1 USING fts5(a, b);
INSERT INTO f1 VALUES('a b', 'c d');
INSERT INTO f1 VALUES('e f', 'a b');
SELECT rowid FROM f1('"" a');
