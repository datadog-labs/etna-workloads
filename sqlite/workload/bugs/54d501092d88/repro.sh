"$SQLITE3" -batch -init /dev/null :memory: <<'SQL'
CREATE TABLE t0(a,b,c,d,e,f,g);
INSERT INTO t0(c,b,f) VALUES(10,10,10);
CREATE VIRTUAL TABLE t1 USING zipfile('h.zip');
INSERT INTO t1 SELECT * FROM t0;
SELECT quote(name),quote(sz) FROM t1;
SQL
echo "exit=$?"
