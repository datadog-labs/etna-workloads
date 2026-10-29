"$SQLITE3" -batch -init /dev/null utf16.db "PRAGMA encoding=UTF16; CREATE TABLE t2(y); CREATE VIRTUAL TABLE t3 USING rtree(id,x1,x2);"
"$SQLITE3" -batch -init /dev/null utf16.db <<'SQL'
WITH t1(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM t1 WHERE x<3)
SELECT rtreecheck('t3') FROM t1;
SQL
echo "exit=$?"
