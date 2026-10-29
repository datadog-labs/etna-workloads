rm -f test.db*
(
  echo "CREATE TABLE t1(a,b); INSERT INTO t1 VALUES(1,2); PRAGMA journal_mode=wal;"
  sleep 2
  echo "PRAGMA journal_mode=delete;"
  echo "PRAGMA journal_mode;"
) | "$SQLITE3" test.db 2>&1 &
sleep 1
# second connection holds a read transaction on the WAL database
( echo "BEGIN; SELECT * FROM t1;"; sleep 3 ) | "$SQLITE3" test.db >/dev/null 2>&1 &
wait
