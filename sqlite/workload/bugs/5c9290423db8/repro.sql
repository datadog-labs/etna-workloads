.dbconfig defensive off
CREATE TABLE t1(id ANY PRIMARY KEY, x TEXT);
INSERT INTO t1 VALUES(1,2),('three','four'),(x'5555','six'),(NULL,'eight');
PRAGMA writable_schema=ON;
UPDATE sqlite_schema SET sql=(sql||'STRICT') WHERE name='t1';
PRAGMA writable_schema=RESET;
PRAGMA integrity_check(t1);
