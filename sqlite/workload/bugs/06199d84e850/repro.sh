"$SQLITE3" dest.db "PRAGMA journal_mode=wal; CREATE TABLE t2(x); INSERT INTO t2 VALUES(1);" >/dev/null
"$SQLITE3" src.db "CREATE TABLE t1(a); INSERT INTO t1 VALUES(2);"
"$SQLITE3" src.db ".backup dest.db"
"$SQLITE3" dest.db "PRAGMA journal_mode; SELECT * FROM t1;"
