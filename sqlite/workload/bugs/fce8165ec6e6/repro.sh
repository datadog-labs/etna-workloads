rm -f test.db test.db-journal test.db-wal test.db-shm
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA locking_mode = EXCLUSIVE;
PRAGMA journal_mode = WAL;
PRAGMA locking_mode = NORMAL;
PRAGMA user_version;
PRAGMA journal_mode = DELETE;
SQL
echo "exit=$?"
