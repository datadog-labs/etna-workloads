rm -f test.db*
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size=1024;
PRAGMA journal_mode=WAL;
CREATE TABLE t1(x);
.filectrl persist_wal 1
PRAGMA journal_mode=TRUNCATE;
PRAGMA journal_mode=MEMORY;
PRAGMA journal_mode=WAL;
PRAGMA journal_mode=PERSIST;
SQL
echo "exit=$?"
