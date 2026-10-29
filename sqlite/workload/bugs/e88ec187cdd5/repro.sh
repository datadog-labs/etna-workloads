mkdir x y
"$SQLITE3" x/test.db "PRAGMA journal_mode=wal; CREATE TABLE t1(x,y); INSERT INTO t1 VALUES('hello','world');"
ln -s ../x/test.db y/test.db
"$SQLITE3" y/test.db "SELECT * FROM t1;"
ls x y
