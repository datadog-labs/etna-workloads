rm -f test.db
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
pragma page_size=1024;
pragma auto_vacuum=1;
create table t(x);
pragma auto_vacuum=2;
vacuum;
pragma auto_vacuum;
SQL
"$SQLITE3" -batch -init /dev/null test.db 'pragma auto_vacuum;'
