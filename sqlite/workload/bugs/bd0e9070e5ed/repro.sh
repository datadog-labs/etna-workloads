# Grow a WAL-mode db past 4GiB, checkpoint, then check index integrity.
rm -f test.db test.db-wal test.db-shm
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size=1024;
PRAGMA journal_mode=WAL;
CREATE TABLE t1(a PRIMARY KEY, b UNIQUE);
WITH RECURSIVE c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<8)
INSERT INTO t1 SELECT printf('%0300d',i), printf('%0500d',i) FROM c;
SQL
# sparse 5000MB file; zero the in-header size so pages are allocated past 4GiB
dd if=/dev/zero of=test.db bs=1 count=1 seek=$((5000*1024*1024)) conv=notrunc 2>/dev/null
printf '\0\0\0\0' | dd of=test.db bs=1 seek=28 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
INSERT INTO t1 SELECT printf('%0300d',100+rowid), printf('%0500d',100+rowid) FROM t1;
SQL
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
SELECT count(*) FROM (SELECT a FROM t1 ORDER BY a);
SELECT count(*) FROM (SELECT b FROM t1 ORDER BY b);
SQL
rm -f test.db test.db-wal test.db-shm
