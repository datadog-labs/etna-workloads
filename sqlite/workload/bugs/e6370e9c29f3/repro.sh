rm -f t.db
"$SQLITE3" t.db "PRAGMA page_size=1024; CREATE TABLE t1(a,b); CREATE INDEX i1 ON t1(a); INSERT INTO t1 VALUES(1,2);"
# set the in-header database size to a negative (as int) value: 0xd0000000
printf '\xd0\x00\x00\x00' | dd of=t.db bs=1 seek=28 conv=notrunc 2>/dev/null
"$SQLITE3" t.db "SELECT * FROM t1;" 2>&1
echo "rc=$?"
