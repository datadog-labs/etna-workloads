"$SQLITE3" -batch -init /dev/null :memory: <<'S'
CREATE VIRTUAL TABLE z USING zipfile('t.zip');
INSERT INTO z(name, data) VALUES('a.txt', 'hello'), ('b.txt', 'world');
CREATE TABLE v(k, d);
INSERT INTO v VALUES('a.txt', 'HELLO'), ('b.txt', 'WORLD');
UPDATE z SET data = v.d FROM v WHERE name = v.k;
SELECT name, data FROM z ORDER BY name;
S
