"$SQLITE3" -batch -init /dev/null :memory: <<'SQL'
CREATE VIRTUAL TABLE z USING zipfile('test.zip');
INSERT INTO z(name, data) VALUES('a.txt','AAAA'),('b.txt','BBBB');
UPDATE OR REPLACE z SET name='b.txt' FROM (VALUES(1),(2));
SELECT name, quote(data) FROM z ORDER BY 1;
SQL
echo "exit=$?"
