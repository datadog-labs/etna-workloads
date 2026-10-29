"$SQLITE3" -batch -init /dev/null test.db "PRAGMA page_size=1024; CREATE TABLE t1(a,b); INSERT INTO t1 VALUES(1,2);"
truncate -s 4294967296 test.db
printf '\0\0\0\0' | dd of=test.db bs=1 seek=28 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db "INSERT INTO t1 VALUES(3, printf('%.30000c','k'));"
"$SQLITE3" -batch -init /dev/null test.db "SELECT a, length(b), b=printf('%.30000c','k') FROM t1 WHERE a=3;"
echo "exit=$?"
rm -f test.db
