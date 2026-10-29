"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
CREATE TABLE t1(a INTEGER PRIMARY KEY AUTOINCREMENT, b TEXT);
INSERT INTO t1(b) VALUES('one');
.dbconfig defensive off
PRAGMA writable_schema=on;
UPDATE sqlite_master SET sql=replace(sql,'sqlite_','x_'),
  name='x_sequence', tbl_name='x_sequence' WHERE name='sqlite_sequence';
SQL
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
INSERT INTO t1(b) VALUES('two');
SQL
echo "exit=$?"
