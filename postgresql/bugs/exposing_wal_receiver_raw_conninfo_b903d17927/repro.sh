set -e
D=$PWD/rtmp; rm -rf $D; mkdir $D
S=$D/s; mkdir $S
P=$D/p
initdb -D $P -A trust >/dev/null
cat >> $P/postgresql.conf <<C
listen_addresses=''
unix_socket_directories='$S'
port=5600
wal_level=replica
max_wal_senders=10
C
echo "local replication all trust" >> $P/pg_hba.conf
pg_ctl -D $P -w -l $D/p.log start >/dev/null
pg_basebackup -D $D/s1 -p 5600 -h $S -R >/dev/null
cp -r $D/s1 $D/s2
echo "port=5601" >> $D/s1/postgresql.conf
echo "port=5602" >> $D/s2/postgresql.conf
pg_ctl -D $D/s1 -w -l $D/s1.log start >/dev/null
pg_ctl -D $D/s2 -w -l $D/s2.log start >/dev/null
psql -X -q -p 5600 -h $S -d postgres -c "create table t as select generate_series(1,1000) a"
until [ "$(psql -X -At -p 5600 -h $S -d postgres -c 'select count(*)=2 from pg_stat_replication')" = t ]; do sleep 0.2; done
pg_ctl -D $P -m smart -w stop >/dev/null
psql -X -At -p 5601 -h $S -d postgres -c "select pg_promote(wait_seconds=>300)"
echo "primary_conninfo='host=$S port=5601 password=dont_show_me'" >> $D/s2/postgresql.auto.conf
pg_ctl -D $D/s2 -w -l $D/s2.log restart >/dev/null
q() { psql -X -At -p 5602 -h $S -d postgres -c "$1"; }
until [ "$(q 'select count(*) from pg_stat_wal_receiver')" = 1 ]; do sleep 0.2; done
psql -X -q -p 5601 -h $S -d postgres -c "insert into t select generate_series(1,1000)"
until [ "$(q 'select count(*) from t')" = 2000 ]; do sleep 0.2; done
q "select count(*) from pg_stat_wal_receiver where conninfo like '%dont_show_me%'"
pg_ctl -D $D/s2 -m fast stop >/dev/null; pg_ctl -D $D/s1 -m fast stop >/dev/null
rm -rf $D
