CREATE VIRTUAL TABLE t USING fts3(a, b);
INSERT INTO t VALUES('one','two');
INSERT INTO t VALUES('two','one');
SELECT rowid FROM t WHERE t MATCH 'B:two';
