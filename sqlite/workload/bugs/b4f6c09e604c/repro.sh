"$SQLITE3" -batch -init /dev/null :memory: \
  "CREATE VIRTUAL TABLE f1 USING fts5(x)" \
  "BEGIN" \
  "INSERT INTO f1(x) VALUES('abc def ghi')" \
  '.output |kill -INT $PPID' \
  ".output stdout" \
  "ROLLBACK" \
  "SELECT 'done'" 2>&1
echo "exit=$?"
