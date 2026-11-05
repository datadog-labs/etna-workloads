rm -f f1; mkfifo f1
psql -X -q -f f1 >/dev/null 2>&1 &
exec 3>f1
echo "CREATE TEMP TABLE empty_foo (val INT);" >&3
sleep 1
S=$(psql -X -At -c "select n.nspname from pg_class c join pg_namespace n on n.oid=c.relnamespace where relname='empty_foo'")
psql -X -c "INSERT INTO $S.empty_foo VALUES (42);" 2>&1
echo "select pg_sleep(0);" >&3
exec 3>&-
wait
rm -f f1
