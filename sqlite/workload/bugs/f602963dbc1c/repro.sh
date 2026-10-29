# Connection 1 opens an empty file; connection 2 turns it into a WAL database;
# then connection 1 sets a different page_size and queries.
mkfifo in1
"$SQLITE3" -batch -init /dev/null test.db < in1 2>&1 &
pid=$!
exec 3> in1
echo "SELECT 1;" >&3
sleep 1
"$SQLITE3" -batch -init /dev/null test.db "PRAGMA page_size=1024; PRAGMA journal_mode=wal; CREATE TABLE t1(a,b); INSERT INTO t1 VALUES(1,2);"
echo "PRAGMA page_size=4096; VACUUM;" >&3
exec 3>&-
wait $pid
echo "exit=$?"
