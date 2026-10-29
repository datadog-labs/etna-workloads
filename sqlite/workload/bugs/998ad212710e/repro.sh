# connection 1 stays open in this process group while another process grows the WAL
rm -f test.db*
mkfifo in
"$SQLITE3" -batch -init /dev/null test.db < in > out1.txt 2>&1 &
pid=$!
exec 3> in
echo "PRAGMA journal_mode=WAL; CREATE TABLE t1(x); INSERT INTO t1 VALUES(randomblob(900)); SELECT count(*) FROM t1;" >&3
sleep 1
{
echo "PRAGMA wal_autocheckpoint=0; BEGIN;"
for i in $(seq 14); do echo "INSERT INTO t1 SELECT randomblob(900) FROM t1;"; done
echo "COMMIT;"
} > w.sql
{ "$SQLITE3" -batch -init /dev/null test.db < w.sql > out2.txt 2>&1; } 2>/dev/null
echo "writer exit: $?"
cat out2.txt
echo "PRAGMA wal_checkpoint; SELECT count(*) FROM t1;" >&3
sleep 1
exec 3>&-
wait $pid
cat out1.txt
"$SQLITE3" -batch -init /dev/null test.db "SELECT count(*) FROM t1; PRAGMA integrity_check;"
