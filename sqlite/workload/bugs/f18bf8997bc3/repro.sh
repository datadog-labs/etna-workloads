"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
CREATE TABLE t(x);
.dbconfig attach_write 0
PRAGMA page_size=4096;
VACUUM;
PRAGMA page_size;
SQL
