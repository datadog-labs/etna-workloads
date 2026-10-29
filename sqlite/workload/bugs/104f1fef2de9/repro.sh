rm -f t.db t.db-journal
"$SQLITE3" -batch -init /dev/null t.db <<'SQL' 2>&1
CREATE VIRTUAL TABLE f USING fts3;
INSERT INTO f VALUES('a');
SELECT count(*) FROM f;
SQL
echo "exit=$?"
rm -f t.db t.db-journal
