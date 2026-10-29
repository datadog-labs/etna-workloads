# Shrink the file with a DROP TABLE, then restore the old header page count
# and version-valid-for fields: counters differ, so the size field must be ignored.
"$SQLITE3" test.db "PRAGMA auto_vacuum=1; CREATE TABLE t1(a,b);"
A=$(dd if=test.db bs=1 skip=28 count=4 2>/dev/null | od -An -tx1 | tr -d ' ')
B=$(dd if=test.db bs=1 skip=92 count=8 2>/dev/null | od -An -tx1 | tr -d ' ')
"$SQLITE3" test.db "DROP TABLE t1;"
hex() { printf "$(echo "$1" | sed 's/../\\x&/g')"; }
hex $A | dd of=test.db bs=1 seek=28 conv=notrunc 2>/dev/null
hex $B | dd of=test.db bs=1 seek=92 conv=notrunc 2>/dev/null
"$SQLITE3" test.db "SELECT * FROM sqlite_master; PRAGMA integrity_check;"
echo "exit=$?"
