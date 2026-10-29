CREATE VIRTUAL TABLE t1 USING fts5(t, tokenize=trigram);
INSERT INTO t1 VALUES('abcdefghij');
SELECT snippet(t1,0,'>','<','...',3) FROM t1('abc');
SELECT snippet(t1,0,'>','<','...',2) FROM t1('cde');
