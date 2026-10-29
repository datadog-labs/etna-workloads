"$SQLITE3" -batch -init /dev/null t.db "PRAGMA page_size=1024; CREATE TABLE t1(x REAL); INSERT INTO t1 VALUES(0.5); VACUUM;"
printf '\x7f\xf8\x00\x00\x00\x00\x00\x00' | dd of=t.db bs=1 seek=2040 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null t.db "SELECT x, typeof(x) FROM t1;"
