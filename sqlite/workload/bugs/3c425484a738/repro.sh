rm -f a.db b.db
"$SQLITE3" -batch -init /dev/null a.db <<SQL 2>&1
CREATE TABLE t1(a,b,c);
ATTACH 'b.db' AS aux;
CREATE TABLE aux.t2(d,e,f);
PRAGMA table_info(t2);
.shell "$SQLITE3" b.db "DROP TABLE t2"
PRAGMA table_info(t2);
SELECT 'done';
SQL
echo "exit=$?"
