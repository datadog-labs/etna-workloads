#!/bin/bash
# Freelist trunk page lists t1's root page as a free leaf; an INSERT..SELECT
# scanning t1 recycles that page while the t1 cursor is still open.
"$SQLITE3" -batch -init /dev/null db >/dev/null <<'SQL'
PRAGMA page_size=1024;
CREATE TABLE t1(a INTEGER PRIMARY KEY, b);
INSERT INTO t1 VALUES(1,'one');
INSERT INTO t1 VALUES(2,'two');
CREATE TABLE t3(x);
CREATE TABLE t2(x PRIMARY KEY) WITHOUT ROWID;
INSERT INTO t2 VALUES(randomblob(100));
DROP TABLE t3;
SQL
# freelist trunk is page 3: next=0, count=1, leaf=2 (t1 root); header count=2
printf '\0\0\0\0\0\0\0\1\0\0\0\2' | dd of=db bs=1 seek=2048 conv=notrunc 2>/dev/null
printf '\0\0\0\2' | dd of=db bs=1 seek=36 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null db 2>&1 <<'SQL'
WITH c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<400)
INSERT INTO t2 SELECT randomblob(100) FROM t1, c WHERE a IN (1,2);
SQL
echo "exit=$?"
