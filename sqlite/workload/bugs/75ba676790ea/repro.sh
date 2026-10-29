rm -f test.db
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size=1024;
CREATE TABLE t1(i INTEGER PRIMARY KEY, j UNIQUE);
WITH s(i) AS (VALUES(1) UNION ALL SELECT i+1 FROM s WHERE i<5000)
INSERT INTO t1 SELECT NULL, randomblob(100) FROM s;
PRAGMA temp_store=0;
PRAGMA cache_size=50;
PRAGMA hard_heap_limit=800000;
VACUUM;
SELECT count(*) FROM t1;
SQL
echo "exit $?"
