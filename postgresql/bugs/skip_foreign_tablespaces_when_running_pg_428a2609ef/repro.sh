D=$PWD/rp_tmp
rm -rf $D; mkdir -p $D/ts
initdb -k -D $D/data >/dev/null 2>&1
pg_ctl -D $D/data -o "-c listen_addresses='' -c unix_socket_directories=$D" -w -l $D/log start >/dev/null 2>&1
psql -X -h $D -d postgres -q -c "create tablespace t location '$D/ts'" -c "create table x(a int) tablespace t" -c "insert into x values (1)"
pg_ctl -D $D/data -w stop >/dev/null 2>&1
mkdir $D/ts/PG_99_999999991
printf 123 > $D/ts/PG_99_999999991/foo
pg_checksums --check -D $D/data >/dev/null 2>&1
echo "exit status: $?"
rm -rf $D
