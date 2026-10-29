"$SQLITE3" -batch -init /dev/null t.db <<'SQL'
PRAGMA page_size=1024;
CREATE TABLE t1(x);
INSERT INTO t1 VALUES(zeroblob(300));
INSERT INTO t1 VALUES(zeroblob(300));
INSERT INTO t1 VALUES(zeroblob(300));
INSERT INTO t1 VALUES(zeroblob(300));
SQL
printf '\0\0\0\1' | dd of=t.db bs=1 seek=1032 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null t.db <<'SQL'
DELETE FROM t1;
PRAGMA integrity_check;
SQL
