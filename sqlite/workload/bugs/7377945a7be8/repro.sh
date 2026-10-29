printf "PRAGMA encoding='UTF16';\nCREATE VIRTUAL TABLE \xC8 USING fts3;\nCREATE VIRTUAL TABLE \xC9 USING s;\n" | "$SQLITE3" -batch -init /dev/null :memory: 2>&1
echo "exit=$?"
