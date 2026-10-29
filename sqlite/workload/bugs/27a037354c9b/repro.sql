.dbconfig defensive off
CREATE VIRTUAL TABLE t1 USING fts5(b, c);
INSERT INTO t1 VALUES('a', 'b');
INSERT INTO t1 VALUES('a', 'b');
UPDATE t1_data SET block = X'000202' WHERE rowid=1;
SELECT * FROM t1('a b') ORDER BY rank;
