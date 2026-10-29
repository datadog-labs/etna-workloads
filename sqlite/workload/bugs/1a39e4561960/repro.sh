"$SQLITE3" -batch -init /dev/null test.db <<'X' >/dev/null
PRAGMA autovacuum = 0;
PRAGMA page_size = 8192;
PRAGMA journal_mode = wal;
CREATE TABLE t1(x, y);
INSERT INTO t1 VALUES(1, 2);
CREATE TABLE t2(x, y);
X
head -c 20480 test.db > trunc.db
"$SQLITE3" -batch -init /dev/null :memory: <<'X' 2>&1
.open --deserialize trunc.db
PRAGMA locking_mode = exclusive;
SELECT * FROM t1;
INSERT INTO t1 VALUES(3, 4);
SELECT * FROM t1;
PRAGMA wal_checkpoint;
X
echo "exit=$?"
