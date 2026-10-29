"$SQLITE3" -batch -init /dev/null :memory: <<'SQL'
CREATE VIRTUAL TABLE zz USING zipfile('test.zip');
BEGIN;
INSERT INTO zz(name, data) VALUES('a.txt', '1');
INSERT INTO zz(name, data) VALUES('b.txt', '2');
INSERT INTO zz(name, data) VALUES('c.txt', '1');
INSERT INTO zz(name, data) VALUES('d.txt', '2');
SELECT name, data FROM zz;
DELETE FROM zz WHERE name='b.txt';
SELECT name, data FROM zz;
COMMIT;
SQL
echo "exit=$?"
