CREATE VIRTUAL TABLE ft USING fts5(a);
INSERT INTO ft VALUES('a b c x c d e');
SELECT highlight(ft, 0, NULL, NULL) FROM ft WHERE ft MATCH 'a+b+c AND c+d+e';
