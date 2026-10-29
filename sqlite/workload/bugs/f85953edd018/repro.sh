"$SQLITE3" -batch -init /dev/null test.db "CREATE TABLE t1(x); INSERT INTO t1 VALUES(1);"
od -An -tx1 -j24 -N4 test.db
"$SQLITE3" -batch -init /dev/null test.db "VACUUM;"
od -An -tx1 -j24 -N4 test.db
