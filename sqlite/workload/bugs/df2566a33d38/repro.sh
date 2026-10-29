rm -f test.db test2.db test.db-journal test2.db-journal
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
ATTACH 'test2.db' AS aux;
PRAGMA main.journal_mode = persist;
PRAGMA aux.journal_mode = persist;
CREATE TABLE abc(a, b, c);
CREATE TABLE aux.def(d, e, f);
BEGIN;
INSERT INTO abc VALUES(1, 2, 3);
INSERT INTO def VALUES(4, 5, 6);
COMMIT;
SQL
echo "journal size: $(stat -c %s test.db-journal)"
