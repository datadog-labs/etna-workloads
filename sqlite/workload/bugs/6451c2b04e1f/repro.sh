# nolock=1 must disable locking even when opened read-only.
rm -f t.db
"$SQLITE3" -batch t.db "CREATE TABLE t1(a); INSERT INTO t1 VALUES(1);"
"$SQLITE3" -batch -init /dev/null t.db <<'SQL' 2>&1
BEGIN EXCLUSIVE;
INSERT INTO t1 VALUES(2);
ATTACH 'file:t.db?mode=ro&nolock=1' AS x;
SELECT * FROM x.t1;
SQL
echo "exit=$?"
