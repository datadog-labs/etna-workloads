CREATE VIRTUAL TABLE t1 USING fts5(one);
INSERT INTO t1 VALUES('abc' || char(65535) || 'def');
INSERT INTO t1 VALUES('ghi' || char(65534) || 'jkl');
CREATE VIRTUAL TABLE vv USING fts5vocab('t1', 'row');
SELECT hex(term) FROM vv;
