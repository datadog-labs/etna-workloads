"$SQLITE3" -batch -init /dev/null :memory: <<'S'
CREATE VIRTUAL TABLE zz USING zipfile('test.zip');
INSERT INTO zz(name, mode, mtime, data, method) VALUES('f.txt', 33188, 1000000000, 'aaaaaaaaaabbbbbbbbbb', 0);
SELECT name, json_extract(zipfile_cds(z), '$.crc32')!=0 FROM zipfile('test.zip');
S
