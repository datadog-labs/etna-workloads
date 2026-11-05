D=$PWD/tmp_arch_data
S=$PWD/tmp_arch_sock
rm -rf $D $S; mkdir -p $S
initdb -D $D >/dev/null 2>&1
cat >> $D/postgresql.conf <<C
archive_mode = on
archive_command = 'false'
listen_addresses = ''
unix_socket_directories = '$S'
autovacuum = off
C
pg_ctl -D $D -w -l $D/log start >/dev/null 2>&1
psql -X -q -h $S -d postgres -c "CREATE TABLE t AS SELECT 1; SELECT pg_switch_wal(); CHECKPOINT;" >/dev/null
sleep 2
pg_ctl -D $D -m immediate stop >/dev/null 2>&1
pg_ctl -D $D -w -l $D/log start >/dev/null 2>&1
echo "ready file after crash recovery:"
ls $D/pg_wal/archive_status | grep -c '^000000010000000000000001\.ready$'
pg_ctl -D $D -m immediate stop >/dev/null 2>&1
rm -rf $D $S
