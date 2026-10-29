export TZ=UTC-5
"$SQLITE3" -batch -init /dev/null :memory: "SELECT datetime('2000-10-29 12:00:00Z', 'localtime','localtime');" 2>&1
