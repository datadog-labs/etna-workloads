rm -f t.db
"$SQLITE3" -batch t.db <<'SQL'
CREATE TABLE t1(a);
CREATE INDEX i1 ON t1(a COLLATE nocase);
INSERT INTO t1 VALUES('Abc2'),('abc1');
.dbconfig defensive off
PRAGMA writable_schema=ON;
UPDATE sqlite_master SET sql='CREATE INDEX i1 ON t1(a COLLATE caseless)' WHERE name='i1';
SQL
"$SQLITE3" -batch t.db "PRAGMA integrity_check" 2>&1; echo "rc=$?"
"$SQLITE3" -batch t.db "REINDEX" 2>&1; echo "rc=$?"
"$SQLITE3" -batch t.db "SELECT * FROM t1 ORDER BY a COLLATE caseless" 2>&1; echo "rc=$?"
