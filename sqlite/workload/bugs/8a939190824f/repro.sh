"$SQLITE3" -batch -init /dev/null test.db <<'S'
CREATE TABLE t(x);
BEGIN;
INSERT INTO t VALUES(1);
PRAGMA journal_mode=memory;
COMMIT;
PRAGMA journal_mode;
S
