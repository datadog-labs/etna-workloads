rm -f a.db b.db
{
echo "CREATE TABLE t1(x);"
echo "CREATE TEMP TRIGGER tr1 BEFORE INSERT ON t1 BEGIN SELECT raise(ABORT,'error'); END;"
echo "ATTACH 'b.db' AS aux;"
echo ".shell $SQLITE3 b.db 'CREATE TABLE t1(a,b,c)'"
echo "INSERT INTO aux.t1 VALUES(1,2,3);"
echo "INSERT INTO main.t1 VALUES(1);"
} | timeout 10 "$SQLITE3" -batch -init /dev/null a.db 2>&1
echo "exit $?"
