"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size = 65536;
PRAGMA autovacuum = 0;
CREATE TABLE t1(a INTEGER PRIMARY KEY, b);
INSERT INTO t1 VALUES(-1, 'abcdefghij');
INSERT INTO t1 VALUES(0, 'abcdefghij');
SQL
# root page is page 2: offset 65536
printf '\0\0' | dd of=test.db bs=1 seek=$((65536+10)) conv=notrunc 2>/dev/null
printf '\0\0' | dd of=test.db bs=1 seek=$((65536+5)) conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db 'DELETE FROM t1 WHERE a=0'
echo "exit=$?"
