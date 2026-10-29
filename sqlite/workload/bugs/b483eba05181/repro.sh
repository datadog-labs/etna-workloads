"$SQLITE3" -batch -init /dev/null dest.db <<'SQL'
pragma page_size=1024;
create table t1(a,b);
create index i1 on t1(a,b);
SQL
: > empty.db
"$SQLITE3" -batch -init /dev/null dest.db ".restore main empty.db"
wc -c < dest.db
