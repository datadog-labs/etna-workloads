"$SQLITE3" -batch test.db "CREATE TABLE t1(x); CREATE TABLE t2(y); CREATE TABLE t3(z);"
mkfifo p
"$SQLITE3" -batch test.db < p 2>&1 &
exec 3>p
echo "SELECT * FROM t1;" >&3
sleep 1
"$SQLITE3" -batch test.db "DROP TABLE t1;"
cat >&3 <<'SQL'
CREATE TEMP TRIGGER r1 AFTER INSERT ON t1 BEGIN INSERT INTO t2 VALUES(new.rowid); END;
SELECT * FROM t3;
SELECT name FROM temp.sqlite_master;
DROP TRIGGER r1;
SQL
exec 3>&-
wait
