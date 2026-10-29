# Connection A caches pages, B commits a change then dies mid-transaction
# (hot journal); A must discard its stale cache when rolling back.
rm -f test.db test.db-journal
"$SQLITE3" test.db "PRAGMA page_size=1024; PRAGMA auto_vacuum=0;
CREATE TABLE t1(a,b); CREATE INDEX i1 ON t1(a,b);
WITH c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<6)
INSERT INTO t1 SELECT i, hex(randomblob(500)) FROM c;"
coproc A { "$SQLITE3" test.db 2>&1; }
echo "SELECT count(*), length(group_concat(b)) FROM t1;" >&${A[1]}
sleep 1
( echo "PRAGMA cache_size=10; UPDATE t1 SET b=hex(randomblob(500));
BEGIN; UPDATE t1 SET b=hex(randomblob(500)); SELECT 'x';"; sleep 5 ) | "$SQLITE3" test.db >/dev/null 2>&1 &
B=$!
sleep 2
kill -9 $B 2>/dev/null; pkill -9 -P $B 2>/dev/null
sleep 0.5
echo "PRAGMA integrity_check;" >&${A[1]}
echo "SELECT count(*) FROM t1;" >&${A[1]}
exec {A[1]}>&-
cat <&${A[0]}
