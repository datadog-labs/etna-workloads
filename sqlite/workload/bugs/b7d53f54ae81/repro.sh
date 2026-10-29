set -e
"$SQLITE3" -batch test.db "PRAGMA journal_mode=WAL; CREATE TABLE t1(a,b); INSERT INTO t1 VALUES(1,2); INSERT INTO t1 VALUES(3,4);" >/dev/null
# second connection reads (and holds a stale wal-index header), stays open
coproc DB2 { "$SQLITE3" -batch test.db; }
echo "SELECT * FROM t1;" >&${DB2[1]}
sleep 1
"$SQLITE3" -batch test.db "INSERT INTO t1 VALUES(5,6);"
# db2 is the last to close; it must checkpoint the latest snapshot
exec {DB2[1]}>&-
wait $DB2_PID || true
ls test.db-wal 2>/dev/null || echo "no wal"
"$SQLITE3" -batch test.db "SELECT * FROM t1;"
