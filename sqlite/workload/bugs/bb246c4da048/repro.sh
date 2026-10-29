rm -f test.db
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA auto_vacuum = 0;
PRAGMA page_size = 1024;
CREATE TABLE t1(x);
CREATE TABLE t2(x);
CREATE TABLE t3(x);
WITH c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<128)
INSERT INTO t1 SELECT printf('%08d',i) FROM c;
DROP TABLE t2;
DROP TABLE t3;
SQL
# freelist leaf entry -> page 6 (a leaf of t1)
printf '\0\0\0\6' | dd of=test.db bs=1 seek=2056 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db "CREATE TABLE t4(x);" "SELECT name,rootpage FROM sqlite_master;"
for i in 20; do
  cp test.db t.db
  echo "i=$i"
  "$SQLITE3" -batch -init /dev/null t.db "INSERT INTO t4 SELECT x FROM t1 WHERE rowid>$i;" 2>&1
  echo "exit=$?"
done
