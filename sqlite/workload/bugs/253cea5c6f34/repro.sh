"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA journal_mode=WAL;
CREATE TABLE t1(a);
SQL
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
SELECT count(*) FROM t1;
.filectrl persist_wal
.filectrl persist_wal 1
.filectrl persist_wal
SQL
