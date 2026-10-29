rm -f z.zip
"$SQLITE3" -batch -init /dev/null :memory: <<'SQL'
CREATE VIRTUAL TABLE t1 USING zipfile('z.zip');
INSERT INTO t1 DEFAULT VALUES;
SQL
"$SQLITE3" -batch -init /dev/null :memory: <<'SQL'
CREATE VIRTUAL TABLE v0 USING zipfile('z.zip');
SAVEPOINT y;
DELETE FROM v0 WHERE 9;
INSERT INTO v0 DEFAULT VALUES;
SELECT 'done';
SQL
echo "exit=$?"
