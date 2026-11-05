D=$PWD/rw_tmp; rm -rf $D; mkdir $D
export PGHOST=$D PGPORT=54399 PGDATABASE=postgres
O="-c listen_addresses= -c unix_socket_directories=$D -c wal_log_hints=on -c port=$PGPORT"
initdb -D $D/a >/dev/null 2>&1
printf "wal_log_hints=on\nwal_keep_size=1GB\n" >> $D/a/postgresql.conf
pg_ctl -D $D/a -o "$O" -l $D/a.log -w start >/dev/null
psql -X -q -c "create table drop_tbl as select 1 x; checkpoint"
pg_basebackup -D $D/b -X stream -R >/dev/null 2>&1
echo "port=54398" >> $D/b/postgresql.conf
pg_ctl -D $D/b -o "-c listen_addresses= -c unix_socket_directories=$D" -l $D/b.log -w start >/dev/null
PGPORT=54398 psql -X -q -c "select pg_promote()" -c "select pg_sleep(1)" >/dev/null
psql -X -q -c "insert into drop_tbl values (2)" -c "drop table drop_tbl"
pg_ctl -D $D/a -w stop >/dev/null
pg_ctl -D $D/b -w stop >/dev/null
pg_rewind -D $D/a --source-pgdata=$D/b >$D/rw.out 2>&1; echo "pg_rewind exit: $?"
sed "s|file .*|file|" $D/rw.out | grep -v "diverged\|common"
rm -rf $D
