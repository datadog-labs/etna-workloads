"$SQLITE3" -batch -init /dev/null :memory: <<SQL 2>&1
CREATE TABLE t1(x,UNIQUE(x$(head -c 100000 /dev/zero | tr '\0' ',' | sed 's/,/,x/g')));
SQL
echo "exit=$?"
