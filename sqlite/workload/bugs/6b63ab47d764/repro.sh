rm -f t.db t.db-journal
"$SQLITE3" -batch -init /dev/null t.db <<'SQL'
PRAGMA locking_mode = exclusive;
PRAGMA journal_mode = persist;
CREATE TABLE one(two, three);
INSERT INTO one VALUES('a', 'b');
BEGIN EXCLUSIVE;
COMMIT;
SELECT 'done';
SQL
