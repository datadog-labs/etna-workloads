"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA journal_mode = persist;
.dbconfig defensive on
PRAGMA journal_mode = off;
SQL
