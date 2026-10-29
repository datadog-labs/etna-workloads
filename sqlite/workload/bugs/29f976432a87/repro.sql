.dbconfig defensive off
BEGIN;
CREATE TABLE p1(x PRIMARY KEY);
CREATE TABLE c1(y);
PRAGMA schema_version = 0;
PRAGMA writable_schema = RESET;
INSERT INTO c1 VALUES(1000);
ROLLBACK;
PRAGMA table_info = p1;
SELECT * FROM p1;
PRAGMA integrity_check;
