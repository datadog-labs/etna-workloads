# A persistent journal (zeroed header) is not hot; a reader must not get
# SQLITE_BUSY just because another connection holds a SHARED lock.
rm -f test.db*
( echo "PRAGMA journal_mode=persist; CREATE TABLE t1(a,b); INSERT INTO t1 VALUES(1,2);"
  echo "BEGIN; SELECT * FROM t1;"; sleep 2 ) | "$SQLITE3" test.db >/dev/null &
sleep 1
"$SQLITE3" test.db "SELECT * FROM t1;" 2>&1
echo "exit=$?"
wait
