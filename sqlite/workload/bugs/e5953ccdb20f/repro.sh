"$SQLITE3" -batch -init /dev/null test.db <<'S' 2>&1
PRAGMA locking_mode=EXCLUSIVE;
CREATE TABLE t1(x);
PRAGMA journal_mode=PERSIST;
PRAGMA journal_mode=DELETE;
PRAGMA locking_mode=NORMAL;
PRAGMA journal_mode=PERSIST;
PRAGMA journal_mode=DELETE;
S
echo "exit $?"
