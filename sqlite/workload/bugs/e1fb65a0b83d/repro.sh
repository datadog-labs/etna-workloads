rm -f test.db
"$SQLITE3" test.db "CREATE TABLE t1(a); CREATE INDEX i1 ON t1(a); INSERT INTO t1 VALUES(1),(2),(3);"
{
  echo "SELECT 1;"
  sleep 1
  echo "SELECT 2 IN (SELECT a FROM t1);"
} | { "$SQLITE3" test.db 2>&1 & sleep 0.3; "$SQLITE3" test.db "DROP INDEX i1"; wait; }
