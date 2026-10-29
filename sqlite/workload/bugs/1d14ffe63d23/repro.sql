CREATE TABLE t1('a'"b",c);
CREATE INDEX i1 ON t1('a');
INSERT INTO t1 VALUES(1,2), (3,4);
ALTER TABLE t1 RENAME COLUMN a TO x;
PRAGMA integrity_check;
SELECT sql FROM sqlite_schema WHERE name='t1';
