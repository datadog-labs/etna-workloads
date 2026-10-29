"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA auto_vacuum=OFF;
PRAGMA page_size=1024;
CREATE TABLE t1(x);
INSERT INTO t1(x) VALUES('varint32-01234567890123456789012345678901234567890123456789');
INSERT INTO t1(x) VALUES('varint32-01234567890123456789012345678901234567890123456789');
SQL
# decrease record 1 serial type length from 0x8103 to 0x8101
printf '\x81\x01' | dd of=test.db bs=1 seek=1923 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db 'SELECT substr(x,1,8) FROM t1' 2>&1
echo "exit=$?"
