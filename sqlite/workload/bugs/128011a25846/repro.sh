rm -f test.zip
"$SQLITE3" -batch -init /dev/null :memory: <<'SQL'
CREATE VIRTUAL TABLE zzz USING zipfile('test.zip');
INSERT INTO zzz(name, data) VALUES('dirname2', NULL);
SELECT name, mode, data FROM zzz;
SQL
