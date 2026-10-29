"$SQLITE3" src.db "PRAGMA page_size=8192; CREATE TABLE t1(x); INSERT INTO t1 VALUES(1);"
"$SQLITE3" -batch -init /dev/null :memory: "PRAGMA page_size=1024; CREATE TABLE t2(x);" ".restore main src.db" "SELECT name FROM sqlite_master;"
