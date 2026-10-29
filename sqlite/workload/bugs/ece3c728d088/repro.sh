rm -f test.db
"$SQLITE3" test.db "PRAGMA encoding=UTF16; CREATE TABLE t1(a); PRAGMA encoding=UTF8; CREATE TABLE t2(b);"
"$SQLITE3" test.db "SELECT name FROM sqlite_master;"
