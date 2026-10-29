rm -f t.db
"$SQLITE3" -batch t.db <<'SQL'
.dbconfig defensive off
CREATE TABLE t1(a,b,c);
CREATE TABLE t2(a,b,c);
PRAGMA writable_schema=1;
UPDATE sqlite_master SET rootpage=NULL WHERE name='t2';
SQL
"$SQLITE3" -batch t.db "SELECT * FROM t2;" 2>&1
echo "exit=$?"
