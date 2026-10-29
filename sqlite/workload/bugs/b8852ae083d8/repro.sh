"$SQLITE3" -batch -init /dev/null test.db <<'SQL' 2>&1
PRAGMA page_size=1024;
.filectrl chunk_size 1048576
CREATE TABLE t1(a, b);
INSERT INTO t1 VALUES(1, zeroblob(1024*900));
DELETE FROM t1;
PRAGMA page_count;
PRAGMA max_page_count = 100;
SQL
echo "exit=$?"
