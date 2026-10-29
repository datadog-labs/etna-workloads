"$SQLITE3" -batch -init /dev/null test.db <<'S'
.dbconfig defensive off
CREATE TABLE t1(a INTEGER PRIMARY KEY, b);
PRAGMA writable_schema = 1;
UPDATE sqlite_schema SET sql = 'CREATE TABLE t1(a INTEGER PRIMARY KEY AUTOINCREMENT, b)';
S
"$SQLITE3" -batch -init /dev/null test.db <<'S'
ALTER TABLE t1 DROP COLUMN b;
SELECT sql FROM sqlite_schema;
S
echo "exit=$?"
