rm -f t.db
"$SQLITE3" t.db "PRAGMA page_size=1024; PRAGMA auto_vacuum=0; CREATE TABLE t1(a); CREATE INDEX i1 ON t1(a); INSERT INTO t1 VALUES(hex(zeroblob(1500))); CREATE TABLE t2(a); INSERT INTO t2 VALUES(1);"
A=$(dd if=t.db bs=1 skip=28 count=4 2>/dev/null | od -An -tx1 | tr -d ' \n')
B=$(dd if=t.db bs=1 skip=92 count=8 2>/dev/null | od -An -tx1 | tr -d ' \n')
"$SQLITE3" t.db "INSERT INTO t1 VALUES(hex(zeroblob(1500)))"
# simulate a pre-3.7.0 writer: stale db-size and change-counter fields
printf "$(echo $A | sed 's/../\\x&/g')" | dd of=t.db bs=1 seek=28 conv=notrunc 2>/dev/null
printf "$(echo $B | sed 's/../\\x&/g')" | dd of=t.db bs=1 seek=92 conv=notrunc 2>/dev/null
"$SQLITE3" t.db "INSERT INTO t2 VALUES(2)"
dd if=t.db bs=1 skip=28 count=4 2>/dev/null | od -An -tx1
"$SQLITE3" t.db "PRAGMA integrity_check; BEGIN; INSERT INTO t2 VALUES(2); SAVEPOINT a; INSERT INTO t2 VALUES(3); ROLLBACK TO a; PRAGMA integrity_check; COMMIT; PRAGMA integrity_check;"
