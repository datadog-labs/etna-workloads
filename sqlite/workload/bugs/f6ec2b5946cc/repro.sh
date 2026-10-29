# Hot journal must be rolled back under the unix-dotfile VFS.
"$SQLITE3" -batch -init /dev/null --vfs unix-dotfile test.db <<'SQL'
PRAGMA page_size=1024;
PRAGMA cache_size=10;
CREATE TABLE t1(x, y, z);
CREATE INDEX t1x ON t1(x);
WITH s(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<1000)
  INSERT INTO t1 SELECT hex(randomblob(20)), hex(randomblob(500)), i FROM s;
BEGIN;
UPDATE t1 SET z=z+1, x=hex(randomblob(20));
.shell cp test.db test.db2
.shell cp test.db-journal test.db2-journal
SQL
"$SQLITE3" -batch -init /dev/null --vfs unix-dotfile test.db2 "PRAGMA integrity_check; SELECT sum(z) FROM t1;" 2>&1
