mkdir tst
"$SQLITE3" tst/test.db "CREATE TABLE t1(x, y); INSERT INTO t1 VALUES(1, 2);"
chmod 555 tst
"$SQLITE3" tst/test.db "SELECT * FROM t1; INSERT INTO t1 VALUES(3, 4); SELECT 'x';" 2>&1
echo "status=$?"
chmod 755 tst
