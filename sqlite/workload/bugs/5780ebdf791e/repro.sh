"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size=1024;
PRAGMA auto_vacuum=0;
BEGIN;
CREATE TABLE t1(x,y);
INSERT INTO t1 VALUES(1,1);
INSERT OR IGNORE INTO t1 SELECT x*2,y FROM t1;
INSERT OR IGNORE INTO t1 SELECT x*3,y FROM t1;
INSERT OR IGNORE INTO t1 SELECT x*5,y FROM t1;
INSERT OR IGNORE INTO t1 SELECT x*7,y FROM t1;
INSERT OR IGNORE INTO t1 SELECT x*11,y FROM t1;
INSERT OR IGNORE INTO t1 SELECT x*13,y FROM t1;
CREATE INDEX t1i1 ON t1(x);
CREATE TABLE t2 AS SELECT x,2 as y FROM t1 WHERE rowid%5!=0;
COMMIT;
SQL
printf '\x04' | dd of=test.db bs=1 seek=2053 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db 'PRAGMA integrity_check' 2>&1
echo "exit=$?"
