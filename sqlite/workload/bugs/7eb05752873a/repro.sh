# Connection B maps only the first chunk of the -shm file, then A writes a
# large WAL and checkpoints it fully; B then rolls back a write transaction.
coproc B { "$SQLITE3" -batch test.db 2>&1; }
"$SQLITE3" -batch test.db >/dev/null <<'SQL'
PRAGMA page_size=1024;
PRAGMA journal_mode=WAL;
PRAGMA wal_autocheckpoint=0;
CREATE TABLE t(x);
SQL
echo "SELECT count(*) FROM t;" >&${B[1]}
sleep 1
"$SQLITE3" -batch test.db >/dev/null <<'SQL'
PRAGMA wal_autocheckpoint=0;
BEGIN;
INSERT INTO t VALUES(randomblob(100));
WITH RECURSIVE c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<150000)
INSERT INTO t SELECT randomblob(100) FROM c;
COMMIT;
PRAGMA wal_checkpoint;
SQL
printf 'BEGIN;\nINSERT INTO t VALUES(1);\nROLLBACK;\nSELECT 1;\n' >&${B[1]}
echo ".exit" >&${B[1]}
cat <&${B[0]}
wait
