# Two long-lived connections; corrupt the wal-index, then checkpoint from the
# second one with a busy timeout (blocking locks) so recovery runs inside it.
mkfifo in1 in2
"$SQLITE3" -batch test.db < in1 2>&1 &
"$SQLITE3" -batch test.db < in2 2>&1 &
exec 3> in1 4> in2
echo ".timeout 1000" >&3
echo ".timeout 1000" >&4
echo "CREATE TABLE t1(x, y); PRAGMA journal_mode=wal; INSERT INTO t1 VALUES(1,2);" >&3
sleep 1
echo "SELECT * FROM t1;" >&4
sleep 1
printf 'blahblahblahblah' | dd of=test.db-shm bs=1 conv=notrunc 2>/dev/null
echo "PRAGMA wal_checkpoint=TRUNCATE;" >&4
sleep 1
exec 3>&- 4>&-
wait
