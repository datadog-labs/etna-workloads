"$SQLITE3" -batch -init /dev/null t.db <<'S'
CREATE TABLE t1(a PRIMARY KEY COLLATE nocase, b COLLATE nocase) WITHOUT ROWID;
INSERT INTO t1 VALUES(1,2);
.dbconfig defensive off
PRAGMA writable_schema=1;
UPDATE sqlite_schema SET sql=replace(sql,'nocase','mysort') WHERE name='t1';
S
"$SQLITE3" -batch -init /dev/null t.db <<'S'
SELECT * FROM t1 WHERE a=1;
CREATE UNIQUE INDEX i1 ON t1(1);
SELECT * FROM t1 WHERE a=1;
S
