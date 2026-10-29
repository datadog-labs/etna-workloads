rm -f t.db
"$SQLITE3" -batch -init /dev/null :memory: <<'SQL' 2>&1
.open file:t.db?cache=shared
PRAGMA encoding=UTF16;
CREATE TABLE t1(x,y);
INSERT INTO t1 VALUES('abc','This is a test string');
.connection 1
.open file:t.db?cache=shared
SELECT * FROM t1;
.connection 2
.open file:t.db?cache=shared
SELECT y FROM t1 WHERE x='abc';
SQL
