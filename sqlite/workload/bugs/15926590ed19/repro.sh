"$SQLITE3" -batch -init /dev/null test.db "PRAGMA page_size=512; CREATE TABLE t1(x);"
# set header page size to 256 (0x0100)
printf '\001\000' | dd of=test.db bs=1 seek=16 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db "SELECT count(*) FROM sqlite_master;" 2>&1
echo "exit=$?"
