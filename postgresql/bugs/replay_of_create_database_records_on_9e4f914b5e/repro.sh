D=$PWD/rtmp; rm -rf $D; mkdir $D
export PGPORT=54399
cat >> $PGDATA/postgresql.conf <<C
allow_in_place_tablespaces=on
wal_level=replica
max_wal_senders=3
listen_addresses=''
unix_socket_directories='$D'
C
cat >> $PGDATA/pg_hba.conf <<C
local replication all trust
C
pg_ctl -D $PGDATA -w -l $D/p.log restart >/dev/null
export PGHOST=$D
psql -X -q -c "create tablespace ts1 location ''" postgres
pg_basebackup -D $D/sb -X stream -c fast -h $D -p $PGPORT >/dev/null 2>&1
cat >> $D/sb/postgresql.conf <<C
port=54398
hot_standby=on
restore_command='cp $PGDATA/pg_wal/%f %p'
C
touch $D/sb/standby.signal
psql -X -q postgres <<S
create database d1 tablespace ts1 strategy file_copy;
drop database d1;
drop tablespace ts1;
S
psql -X -q -c "select pg_switch_wal()" postgres >/dev/null
# standby starts replaying; wipe tablespace dir first so create db finds it missing
rm -rf $D/sb/pg_tblspc/*
pg_ctl -D $D/sb -w -t 20 -l $D/s.log start >/dev/null 2>&1
sleep 2
if PGPORT=54398 psql -X -Atq -c "select 'standby up'" postgres 2>/dev/null; then :; else echo "standby failed"; fi
pg_ctl -D $D/sb -m immediate stop >/dev/null 2>&1
pg_ctl -D $PGDATA -m fast stop >/dev/null 2>&1
