CREATE VIRTUAL TABLE t1 USING fts5(y, tokenize=trigram);
INSERT INTO t1 VALUES('abcdefghijklm');
SELECT highlight(t1, 0, '(', ')') FROM t1('def ghi');
SELECT highlight(t1, 0, '(', ')') FROM t1('efg ghi');
CREATE VIRTUAL TABLE ft2 USING fts5(a, tokenize="trigram");
INSERT INTO ft2 VALUES('abc x cde');
INSERT INTO ft2 VALUES('abcde');
SELECT highlight(ft2, 0, '[', ']') FROM ft2 WHERE ft2 MATCH 'abc AND cde';
