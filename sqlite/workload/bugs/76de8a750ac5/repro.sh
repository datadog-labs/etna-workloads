printf x > test.db-journal
"$SQLITE3" -batch -init /dev/null test.db "PRAGMA locking_mode = EXCLUSIVE; SELECT * FROM sqlite_master;" 2>&1
echo "exit=$?"
