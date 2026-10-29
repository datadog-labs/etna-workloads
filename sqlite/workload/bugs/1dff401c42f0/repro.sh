# Connection 2 holds a read lock on aux.db so connection 1's COMMIT fails
# with SQLITE_BUSY (fts5 left in state 2), then connection 1 writes fts5 again.
rm -f main.db aux.db
mkfifo p1 p2
"$SQLITE3" -batch -init /dev/null main.db <p1 >out1 2>&1 &
pid1=$!
"$SQLITE3" -batch -init /dev/null main.db <p2 >out2 2>&1 &
pid2=$!
exec 3>p1 4>p2
echo "PRAGMA page_size=1024; ATTACH 'aux.db' AS aux; CREATE TABLE aux.t2(x,y); INSERT INTO t2 VALUES(1,2); CREATE VIRTUAL TABLE x1 USING fts5(a); BEGIN; INSERT INTO x1 VALUES('abc'); INSERT INTO t2 VALUES(3,4);" >&3
sleep 1
echo "ATTACH 'aux.db' AS aux; BEGIN; SELECT * FROM t2;" >&4
sleep 1
printf "COMMIT;\nINSERT INTO x1 VALUES('def');\n" >&3
sleep 1
echo "END;" >&4
sleep 1
printf "COMMIT;\nSELECT * FROM x1;\n" >&3
sleep 1
echo "SELECT * FROM x1;" >&4
exec 3>&- 4>&-
wait $pid1; echo "exit1=$?"
wait $pid2; echo "exit2=$?"
cat out1 out2
rm -f p1 p2
