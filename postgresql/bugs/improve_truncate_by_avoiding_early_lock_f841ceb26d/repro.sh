psql -X -q -c "create table tt(a int); create role r_unpriv;"
( printf "begin; select count(*) from tt; select pg_sleep(4);\n" | psql -X -q -o /dev/null ) &
sleep 1
psql -X -q <<SQL 2>&1
set role r_unpriv;
set lock_timeout='1s';
truncate tt;
SQL
wait
