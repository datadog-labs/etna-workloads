"$SQLITE3" -batch -init /dev/null test.db <<'S'
PRAGMA locking_mode = EXCLUSIVE;
PRAGMA journal_mode = PERSIST;
CREATE VIRTUAL TABLE vt0 USING fts5(c0);
PRAGMA data_version;
INSERT INTO vt0(vt0) VALUES('integrity-check');
PRAGMA data_version;
S
