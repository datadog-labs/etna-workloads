D=$PWD/rtmp; rm -rf $D; mkdir -p $D/arch $D/sock
O="-c listen_addresses= -c unix_socket_directories=$D/sock"
initdb -D $D/p -A trust >/dev/null 2>&1
cat >> $D/p/postgresql.conf <<C
wal_level=replica
max_wal_senders=5
archive_mode=on
archive_command='cp %p $D/arch/%f'
hot_standby=on
port=54331
C
echo "host replication all samehost trust" >> $D/p/pg_hba.conf
pg_ctl -D $D/p -o "$O" -w -l $D/p.log start >/dev/null
pg_basebackup -h $D/sock -p 54331 -D $D/s -X stream >/dev/null 2>&1
sed -i 's/^port=.*/port=54332/' $D/s/postgresql.conf
touch $D/s/standby.signal
echo "primary_conninfo='host=$D/sock port=54331'" >> $D/s/postgresql.conf
pg_ctl -D $D/p -m fast -w stop >/dev/null
touch $D/p/standby.signal
pg_ctl -D $D/p -o "$O" -w -l $D/p.log start >/dev/null
pg_ctl -D $D/p -w promote >/dev/null
pg_ctl -D $D/s -o "$O" -w -l $D/s.log start >/dev/null
psql -X -h $D/sock -p 54331 -d postgres -c "CREATE TABLE t AS SELECT 1 a" >/dev/null
for i in $(seq 1 30); do
  r=$(psql -X -At -h $D/sock -p 54332 -d postgres -c "select count(*) from t" 2>/dev/null)
  [ "$r" = 1 ] && break
  sleep 1
done
echo "standby rows: $r"
pg_ctl -D $D/s -m immediate stop >/dev/null 2>&1
pg_ctl -D $D/p -m immediate stop >/dev/null 2>&1
