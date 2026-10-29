export TZ=EST5
"$SQLITE3" -batch -init /dev/null :memory: <<'S'
SELECT datetime('2000-10-29 12:00 +00:00','utc','utc');
SELECT datetime('2000-10-29 12:00:00-00:00','utc','utc');
S
