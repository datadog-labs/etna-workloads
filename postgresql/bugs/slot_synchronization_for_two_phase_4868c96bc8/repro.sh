D=$PWD/rp_tmp; rm -rf $D; mkdir $D
P=$D/p; S=$D/s
initdb -D $P >/dev/null 2>&1
cat >> $P/postgresql.conf <<C
wal_level = logical
listen_addresses = ''
unix_socket_directories = '$D'
port = 54399
autovacuum = off
C
echo "local replication all trust" >> $P/pg_hba.conf
pg_ctl -D $P -l $D/p.log -w start >/dev/null
export PGHOST=$D PGPORT=54399 PGDATABASE=postgres
psql -X -q -c "select pg_create_physical_replication_slot('sb')" >/dev/null
pg_basebackup -D $S -R -X stream -S sb 2>&1
cat >> $S/postgresql.conf <<C
port = 54398
hot_standby_feedback = on
primary_slot_name = 'sb'
primary_conninfo = 'host=$D port=54399 dbname=postgres'
C
pg_ctl -D $S -l $D/s.log -w start >/dev/null
psql -X -q -c "select pg_create_logical_replication_slot('ls','pgoutput',false,true,true)" >/dev/null
psql -X -q -c "select pg_switch_wal()" >/dev/null
for i in $(seq 1 50); do
  psql -X -At -p 54398 -c "select 1 from pg_stat_wal_receiver" | grep -q 1 && break; sleep 0.2
done
sleep 1
for i in $(seq 1 20); do
  psql -X -q -p 54398 -c "select pg_sync_replication_slots()" >/dev/null 2>&1
  r=$(psql -X -At -p 54398 -c "select count(*) from pg_replication_slots where slot_name='ls'")
  [ "$r" = 1 ] && break; sleep 0.5
done
psql -X -At -p 54398 -c "select slot_name, synced, two_phase, two_phase_at is not null from pg_replication_slots"
psql -X -At -c "select slot_name, two_phase, two_phase_at is not null from pg_replication_slots"
pg_ctl -D $S -m immediate stop >/dev/null; pg_ctl -D $P -m immediate stop >/dev/null
rm -rf $D
