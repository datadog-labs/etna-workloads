D=$PWD/rc_data
rm -rf $D
initdb -D $D >/dev/null 2>&1
S=$PWD/rc_sock; rm -rf $S; mkdir $S
O="-c listen_addresses= -c unix_socket_directories=$S -c port=5999"
pg_ctl -D $D -o "$O" -w -l $PWD/rc_log start >/dev/null
psql -X -h $S -p 5999 -d postgres -c "create table t(a int); insert into t values (1); select * from t;" >/dev/null
pg_ctl -D $D -m fast -w stop >/dev/null
printf 'XYZ' >> $D/pg_stat/pgstat.stat
if pg_ctl -D $D -o "$O" -w -l $PWD/rc_log start >/dev/null 2>&1; then
  echo "start ok"
  psql -X -h $S -p 5999 -d postgres -Atc "select count(*) from pg_stat_database where datname='postgres'"
  pg_ctl -D $D -m fast -w stop >/dev/null
else
  echo "start failed"
fi
rm -rf $D $S
