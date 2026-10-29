S() { "$SQLITE3" -batch -init /dev/null "$@"; }
S t.db "PRAGMA page_size=1024; PRAGMA auto_vacuum=1; CREATE TABLE t1(x); CREATE TABLE t2(x); INSERT INTO t1 VALUES(randomblob(100));"
B=$(dd if=t.db bs=1 skip=92 count=8 2>/dev/null | od -An -tx1)
A=$(dd if=t.db bs=1 skip=28 count=4 2>/dev/null | od -An -tx1)
S t.db "WITH c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<60) INSERT INTO t2 SELECT randomblob(100) FROM c"
# restore the old header size and change counter, as an old-version writer would leave them
w() { off=$1; shift; for b in "$@"; do printf "\\x$b" | dd of=t.db bs=1 seek=$off conv=notrunc 2>/dev/null; off=$((off+1)); done; }
w 28 $A
w 92 $B
S t.db ".backup bak.db"
S bak.db "PRAGMA integrity_check"
