rm -f t.db
"$SQLITE3" t.db <<'S'
CREATE TABLE t6(a);
INSERT INTO t6 VALUES(9);
.dbconfig defensive off
PRAGMA writable_schema=1;
UPDATE sqlite_master SET sql='CREATE TABLE t6(a CHECK (myfunc(a)))' WHERE name='t6';
S
"$SQLITE3" t.db <<'S'
SELECT * FROM t6;
INSERT INTO t6 VALUES(8);
S
