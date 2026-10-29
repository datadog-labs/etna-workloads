rm -f t.db
"$SQLITE3" t.db <<'S'
CREATE TABLE t1(x INTEGER PRIMARY KEY, y);
CREATE UNIQUE INDEX t1y ON t1(y);
INSERT INTO t1 VALUES(111,'AAA'),(222,'BBB'),(333,'CCC');
CREATE TABLE t2(z);
INSERT INTO t2 VALUES('BBB'),('AAA');
ANALYZE sqlite_schema;
INSERT INTO sqlite_stat1 VALUES('t1','t1y','100 1');
S
"$SQLITE3" t.db "SELECT t1.x FROM t2 CROSS JOIN t1 WHERE t2.z = t1.y AND t1.x IN (111, 222);" 2>&1
echo "exit=$?"
