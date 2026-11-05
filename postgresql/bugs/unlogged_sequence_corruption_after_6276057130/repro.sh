D=$PWD/sb_tmp
rm -rf $D; mkdir $D
pg_basebackup -D $D/sb -c fast -X stream >/dev/null 2>&1
SOCK=$D/sock; mkdir $SOCK
cat >> $D/sb/postgresql.conf <<C
port = 54399
unix_socket_directories = '$SOCK'
hot_standby = on
C
touch $D/sb/standby.signal
echo "primary_conninfo = 'host=$PGHOST port=$PGPORT'" >> $D/sb/postgresql.conf
pg_ctl -D $D/sb -l $D/log -w start >/dev/null 2>&1
psql -X -q -c "create unlogged sequence s1" -c "select pg_switch_wal()" >/dev/null
for i in $(seq 100); do
  [ "$(psql -X -At -h $SOCK -p 54399 -c "select to_regclass('s1') is not null" 2>/dev/null)" = t ] && break
  sleep 0.2
done
sleep 1
pg_ctl -D $D/sb -w promote >/dev/null 2>&1
for i in $(seq 100); do
  [ "$(psql -X -At -h $SOCK -p 54399 -c "select pg_is_in_recovery()" 2>/dev/null)" = f ] && break
  sleep 0.2
done
psql -X -h $SOCK -p 54399 -c "select nextval('s1')" 2>&1 | grep -v '^$' | sed 's/^psql:.*ERROR/ERROR/' | head -3
pg_ctl -D $D/sb -m immediate stop >/dev/null 2>&1
rm -rf $D
