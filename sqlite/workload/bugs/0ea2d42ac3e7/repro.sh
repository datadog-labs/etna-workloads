"$SQLITE3" -batch -init /dev/null u16.db "PRAGMA encoding='UTF-16le'; CREATE TABLE t2(d,e,f); INSERT INTO t2 VALUES('d','e','f');"
"$SQLITE3" -batch -init /dev/null :memory: 2>&1 <<EOS
.open test.db
PRAGMA encoding='utf-8';
CREATE TABLE t1(a,b,c);
INSERT INTO t1 VALUES('a','b','c');
.shell "$SQLITE3" u16.db ".backup test.db"
SELECT * FROM t2;
EOS
echo "exit=$?"
