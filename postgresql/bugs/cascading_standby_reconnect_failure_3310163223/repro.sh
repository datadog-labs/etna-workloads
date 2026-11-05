D=$PWD/rtmp; rm -rf $D; mkdir -p $D/arch $D/sock
P=$((PGPORT+11)); S=$((PGPORT+12)); C=$((PGPORT+13))
q() { psql -X -h $D/sock -p $1 -d postgres -Atc "$2"; }
initdb -D $D/p >/dev/null
cat >> $D/p/postgresql.conf <<EOC
listen_addresses=''
unix_socket_directories='$D/sock'
port=$P
wal_level=replica
archive_mode=on
archive_command='cp %p $D/arch/%f'
max_wal_senders=10
wal_keep_size=128MB
checkpoint_timeout=1h
EOC
echo "local replication all trust" >> $D/p/pg_hba.conf
pg_ctl -D $D/p -l $D/p.log -w start >/dev/null
pg_basebackup -h $D/sock -p $P -D $D/s -X stream
cat >> $D/s/postgresql.conf <<EOC
port=$S
primary_conninfo='host=$D/sock port=$P'
EOC
touch $D/s/standby.signal
pg_ctl -D $D/s -l $D/s.log -w start >/dev/null
until q $S "select 1" >/dev/null 2>&1; do sleep 0.2; done
pg_basebackup -h $D/sock -p $S -D $D/c -X stream
cat >> $D/c/postgresql.conf <<EOC
port=$C
primary_conninfo='host=$D/sock port=$S'
restore_command='cp $D/arch/%f %p'
wal_retrieve_retry_interval=500ms
EOC
touch $D/c/standby.signal
pg_ctl -D $D/c -l $D/c.log -w start >/dev/null
q $P "create table t as select generate_series(1,1000) id"
until [ "$(q $C 'select count(*) from t' 2>/dev/null)" = 1000 ]; do sleep 0.3; done
echo "initial replicated"
echo "primary_conninfo=''" >> $D/s/postgresql.conf
pg_ctl -D $D/s reload >/dev/null
until [ "$(q $S 'select count(*) from pg_stat_wal_receiver')" = 0 ]; do sleep 0.3; done
pg_ctl -D $D/c -w stop >/dev/null
q $P "checkpoint"
q $P "insert into t select generate_series(1001,2000)"
W=$(q $P "select pg_walfile_name(pg_current_wal_lsn())")
q $P "select pg_switch_wal()" >/dev/null
until [ "$(q $P "select count(*) from pg_stat_archiver where last_archived_wal >= '$W'")" = 1 ]; do sleep 0.3; done
pg_ctl -D $D/c -l $D/c2.log -w start >/dev/null
until [ "$(q $C 'select count(*) from t' 2>/dev/null)" = 2000 ]; do sleep 0.3; done
echo "archive replayed"
found=no
for i in $(seq 1 40); do
  r=$(q $C "select count(*) from pg_stat_activity where backend_type='walreceiver' and wait_event='WalReceiverUpstreamCatchup'")
  if [ "$r" = 1 ]; then found=yes; break; fi
  sleep 0.5
done
echo "walreceiver waiting for upstream: $found"
sleep 2
if grep -q "ahead of the WAL flush position" $D/s.log; then echo "start point error: yes"; else echo "start point error: no"; fi
for x in c s p; do pg_ctl -D $D/$x -m immediate stop >/dev/null 2>&1; done
rm -rf $D
