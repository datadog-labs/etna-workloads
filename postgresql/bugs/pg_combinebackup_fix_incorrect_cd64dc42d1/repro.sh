D=$PWD/rtmp; rm -rf $D; mkdir -p $D/ts $D/tsb1 $D/tsb2 $D/tsc
initdb -D $D/p -A trust >/dev/null 2>&1
cat >> $D/p/postgresql.conf <<EOM
summarize_wal = on
unix_socket_directories = '$D'
listen_addresses = ''
port = 54399
wal_level = replica
max_wal_senders = 3
EOM
pg_ctl -D $D/p -l $D/log -w start >/dev/null 2>&1
P="psql -X -q -h $D -p 54399 postgres"
$P -c "CREATE TABLESPACE ts1 LOCATION '$D/ts'" -c "CREATE TABLE t (a int, b text) TABLESPACE ts1" -c "INSERT INTO t VALUES (1,'x')"
pg_basebackup -h $D -p 54399 -D $D/b1 --no-sync -cfast -T$D/ts=$D/tsb1
$P -c "UPDATE t SET b='y'"
pg_basebackup -h $D -p 54399 -D $D/b2 --no-sync -cfast -T$D/ts=$D/tsb2 --incremental $D/b1/backup_manifest
pg_combinebackup $D/b1 $D/b2 -o $D/out -T$D/tsb2=$D/tsc >/dev/null 2>&1
echo "combine exit: $?"
pg_ctl -D $D/p -m immediate stop >/dev/null 2>&1
rm -rf $D
