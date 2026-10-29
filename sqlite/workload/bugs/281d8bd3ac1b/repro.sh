mkdir src && cd src
"$SQLITE3" -batch test.db "CREATE TABLE t1(a,b,c); INSERT INTO t1 VALUES(1,2,3);"
# hold a transaction open so a journal exists, then snapshot db + journal
( echo "BEGIN; INSERT INTO t1 VALUES(4,5,6);"; sleep 2 ) | "$SQLITE3" -batch test.db &
sleep 1
cd .. && mkdir work && cp src/test.db work/ && cp src/test.db-journal work/
wait
cd work
printf '\xd9\xd5\x05\xf9\x20\xa1\x63\xd7' | dd of=test.db-journal bs=1 conv=notrunc 2>/dev/null
chmod 444 test.db-journal
"$SQLITE3" -batch test.db "SELECT * FROM t1;" 2>&1
echo "exit=$?"
