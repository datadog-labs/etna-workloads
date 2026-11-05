D=$PWD/rt; rm -rf $D; mkdir -p $D/arch
cat > $D/cp.sh <<'X'
#!/bin/sh
case "$1" in *history*) cp "$1" "$2";; esac
exit 0
X
chmod +x $D/cp.sh
P1=$((PGPORT+11)); P2=$((PGPORT+12)); P3=$((PGPORT+13))
C="-c listen_addresses= -c unix_socket_directories=$D -c fsync=off"
initdb -D $D/p -A trust >/dev/null 2>&1
cat >> $D/p/postgresql.conf <<X
archive_mode=on
archive_command='$D/cp.sh %p $D/arch/%f'
wal_level=replica
max_wal_senders=5
hot_standby=on
port=$P1
listen_addresses=''
unix_socket_directories='$D'
fsync=off
X
echo "local replication all trust" >> $D/p/pg_hba.conf
pg_ctl -D $D/p -w -l $D/p.log start >/dev/null
pg_basebackup -h $D -p $P1 -D $D/s -Xs >/dev/null 2>&1
echo "port=$P2" >> $D/s/postgresql.conf
echo "primary_conninfo='host=$D port=$P1'" >> $D/s/postgresql.conf
touch $D/s/standby.signal
pg_ctl -D $D/s -w -l $D/s.log start >/dev/null
pg_basebackup -h $D -p $P2 -D $D/c -Xnone >/dev/null 2>&1
echo "port=$P3" >> $D/c/postgresql.conf
echo "primary_conninfo='host=$D port=$P2'" >> $D/c/postgresql.conf
echo "restore_command='cp $D/arch/%f %p'" >> $D/c/postgresql.conf
echo "recovery_target_timeline='latest'" >> $D/c/postgresql.conf
touch $D/c/standby.signal
pg_ctl -D $D/s promote -w >/dev/null
psql -X -h $D -p $P2 -d postgres -Atc "select pg_switch_wal()" >/dev/null
for i in $(seq 100); do
 [ -f $D/arch/00000002.history ] && break; sleep 0.2; done
sleep 1
pg_ctl -D $D/c -w -t 20 -l $D/c.log start >/dev/null 2>&1
psql -X -h $D -p $P2 -d postgres -Atc "create table t as select 1 a" >/dev/null
for i in $(seq 30); do
 r=$(psql -X -h $D -p $P3 -d postgres -Atc "select count(*) from t" 2>/dev/null) && break; sleep 1; done
echo "cascade count: $r"
pg_ctl -D $D/c -m immediate stop >/dev/null 2>&1
pg_ctl -D $D/s -m immediate stop >/dev/null 2>&1
pg_ctl -D $D/p -m immediate stop >/dev/null 2>&1
