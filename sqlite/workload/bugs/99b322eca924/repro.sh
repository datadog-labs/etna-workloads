Y=$(printf 'y%.0s' $(seq 1 7000))
{
echo "PRAGMA page_size=4096; PRAGMA auto_vacuum=INCREMENTAL; PRAGMA journal_mode=wal;"
echo "BEGIN;"
for i in $(seq 0 36); do
  echo "CREATE TABLE t$i (a TEXT);"
  [ $i = 0 ] && echo "INSERT INTO t0 VALUES('$Y');"
done
echo "DELETE FROM t0;"
for i in $(seq 0 36); do echo "DROP TABLE t$i;"; done
echo "COMMIT; PRAGMA integrity_check; PRAGMA wal_checkpoint;"
} | "$SQLITE3" -batch -init /dev/null test.db 2>&1
echo "exit=$?"
