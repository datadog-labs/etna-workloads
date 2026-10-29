rm -f test.db
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size=1024;
PRAGMA auto_vacuum=0;
CREATE TABLE t1(a,b);
WITH RECURSIVE c(i) AS (VALUES(1) UNION ALL SELECT i+1 FROM c WHERE i<10)
  INSERT INTO t1(a,b) SELECT i, zeroblob(700) FROM c;
SQL
printf '\002' | dd of=test.db bs=1 seek=$((2*1024-2)) conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db 'DROP TABLE t1;' 2>&1
echo "exit=$?"
