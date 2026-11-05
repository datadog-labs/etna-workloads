D=$PWD/tmp_r; rm -rf $D; mkdir -p $D
P=54331; S=54332
opt="-c listen_addresses= -c unix_socket_directories=$D"
initdb -D $D/p -A trust >/dev/null 2>&1
echo "wal_level=replica
max_wal_senders=5
hot_standby=on" >> $D/p/postgresql.conf
pg_ctl -D $D/p -o "$opt -p $P" -w -l $D/p.log start >/dev/null
psql -X -q -h $D -p $P postgres -c "create table t(d text)"
pg_basebackup -h $D -p $P -D $D/s -R >/dev/null 2>&1
pg_ctl -D $D/s -o "$opt -p $S" -w -l $D/s.log start >/dev/null
cat > $D/q.sql <<EOS
select * from t order by d;
\\! psql -X -q -h $D -p $P postgres -c "insert into t values ('one')"
\\! sleep 2
select * from t order by d;
EOS
psql -X -q -h $D -p $S postgres -f $D/q.sql
pg_ctl -D $D/s -m fast stop >/dev/null
pg_ctl -D $D/p -m fast stop >/dev/null
