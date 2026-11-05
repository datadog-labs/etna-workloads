D=$PWD/rt; rm -rf $D; mkdir $D
export PGHOST=$D; PORT=54711
mk() { # name port
  :; }
initdb -D $D/p -A trust >/dev/null
cat >> $D/p/postgresql.conf <<C
port=$PORT
unix_socket_directories='$D'
listen_addresses=''
wal_level=replica
max_wal_senders=5
hot_standby=on
wal_keep_size=64MB
C
echo "local replication all trust" >> $D/p/pg_hba.conf
pg_ctl -D $D/p -l $D/p.log -w start >/dev/null
export PGPORT=$PORT
pg_basebackup -D $D/s1 -X stream -R -c fast 2>/dev/null
pg_basebackup -D $D/s2 -X stream -R -c fast 2>/dev/null
for s in 1 2; do
  echo "port=$((PORT+s))" >> $D/s$s/postgresql.conf
  pg_ctl -D $D/s$s -l $D/s$s.log -w start >/dev/null
done
psql -X -qc "create table t(i int); insert into t select generate_series(1,10)" postgres
psql -X -qc "checkpoint" postgres
pg_ctl -D $D/p -m fast -w stop >/dev/null
pg_ctl -D $D/s1 -w promote >/dev/null
echo "primary_conninfo='port=$((PORT+1)) host=$D'" >> $D/s2/postgresql.auto.conf
pg_ctl -D $D/s2 -w stop >/dev/null; pg_ctl -D $D/s2 -l $D/s2b.log -w start >/dev/null
PGPORT=$((PORT+1)) psql -X -qc "insert into t select generate_series(1,10)" postgres
sleep 4
grep -c "terminating walreceiver process due to administrator command" $D/s2b.log
for s in s2 s1; do pg_ctl -D $D/$s -m immediate stop >/dev/null; done
