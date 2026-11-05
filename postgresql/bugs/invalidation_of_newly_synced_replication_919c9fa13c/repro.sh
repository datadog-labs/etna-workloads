D=$PWD/rtmp
rm -rf $D
mkdir -p $D
P=$D/p
S=$D/s
initdb -D $P >/dev/null 2>&1
cat >> $P/postgresql.conf <<C
wal_level=logical
listen_addresses=''
unix_socket_directories='$D'
port=54871
autovacuum=off
C
pg_ctl -D $P -w -l $D/p.log start >/dev/null
q() {
  psql -X -qAt -h $D -p $1 -d postgres -c "$2"
}
q 54871 "select pg_create_physical_replication_slot('phys_slot')" >/dev/null
q 54871 "select pg_create_logical_replication_slot('failover_slot','pgoutput',false,false,true)" >/dev/null
pg_basebackup -h $D -p 54871 -D $S -X stream -S phys_slot >/dev/null 2>&1
cat >> $S/postgresql.conf <<C
port=54872
hot_standby_feedback=on
primary_slot_name='phys_slot'
primary_conninfo='host=$D port=54871 dbname=postgres'
C
touch $S/standby.signal
pg_ctl -D $S -w -l $D/s.log start >/dev/null
q 54871 "create table t as select generate_series(1,1000) i" >/dev/null
q 54871 "select pg_switch_wal()" >/dev/null
q 54871 "checkpoint" >/dev/null
q 54871 "select pg_switch_wal()" >/dev/null
sleep 3
q 54872 "checkpoint" >/dev/null
q 54872 "alter system set sync_replication_slots=on" >/dev/null
q 54872 "select pg_reload_conf()" >/dev/null
for i in $(seq 60); do
  n=$(q 54872 "select count(*) from pg_replication_slots where slot_name='failover_slot'")
  [ "$n" = 1 ] && break
  sleep 1
done
echo "synced slots: $n"
echo "restart_lsn not behind redo:"
q 54872 "select s.restart_lsn >= c.redo_lsn from pg_replication_slots s, pg_control_checkpoint() c where slot_name='failover_slot'"
pg_ctl -D $S -m immediate stop >/dev/null
pg_ctl -D $P -m immediate stop >/dev/null
rm -rf $D
