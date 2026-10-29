"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
.dbconfig defensive off
CREATE VIRTUAL TABLE t1 USING fts5(a, tokenize=ascii);
INSERT INTO t1 VALUES('a b c'), ('d e f');
PRAGMA writable_schema = 1;
UPDATE sqlite_schema SET sql = 'CREATE VIRTUAL TABLE t1 USING fts5(a, tokenize=blah)' WHERE name = 't1';
SQL
"$SQLITE3" -batch -init /dev/null test.db 2>&1 <<'SQL'
SELECT highlight(t1, 0, '[', ']') FROM t1;
SQL
echo "exit=$?"
