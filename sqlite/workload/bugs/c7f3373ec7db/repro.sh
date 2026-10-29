nm=$(head -c 10000 /dev/zero | tr '\0' x)
printf '.limit length 10000\nCREATE TABLE %s (x PRIMARY KEY);\n' "$nm" | "$SQLITE3" -batch -init /dev/null :memory: 2>&1 | cut -c1-200
echo "exit=${PIPESTATUS[1]}"
