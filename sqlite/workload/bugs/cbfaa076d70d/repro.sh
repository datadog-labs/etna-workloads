mkdir subdir
printf 1 > subdir/x1.txt
printf 11 > subdir/x2.txt
"$SQLITE3" -batch -init /dev/null :memory: <<'SQL'
CREATE TABLE d AS SELECT 'subdir' d;
CREATE TABLE x AS SELECT 1 x;
SELECT name FROM d JOIN x JOIN fsdir('.', d) ORDER BY 1;
SQL
echo "exit=$?"
