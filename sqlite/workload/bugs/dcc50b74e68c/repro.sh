rm -f t.db
"$SQLITE3" t.db <<'S'
CREATE TABLE t1(x,y);
CREATE INDEX t1i1 ON t1(x);
.dbconfig defensive off
PRAGMA writable_schema=1;
UPDATE sqlite_master SET sql='CREATE INDEX main.t1i1 ON t1(x)' WHERE name='t1i1';
S
"$SQLITE3" t.db 'SELECT count(*) FROM sqlite_master;'
echo "exit=$?"
