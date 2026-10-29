rm -f t.db
"$SQLITE3" t.db <<'SQL' 2>&1
.dbconfig defensive off
CREATE TABLE t1(a,b,c); INSERT INTO t1 VALUES(1,'abc',3);
CREATE INDEX ex1 ON t1(c) WHERE b IS 'abc' COLLATE nocase;
PRAGMA writable_schema=1;
UPDATE sqlite_schema SET sql=replace(sql,'nocase','xyz') WHERE name='ex1';
SQL
"$SQLITE3" t.db "SELECT * FROM t1" 2>&1
echo "exit=$?"
