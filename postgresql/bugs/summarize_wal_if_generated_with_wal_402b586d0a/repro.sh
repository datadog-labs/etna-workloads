D=$PWD/rtmp_$$
mkdir -p $D
export PGPORT=54399 PGHOST=$D
initdb -D $D/n -A trust >/dev/null 2>&1
cat >> $D/n/postgresql.conf <<EOM
summarize_wal = on
wal_keep_size = '1GB'
listen_addresses = ''
unix_socket_directories = '$D'
EOM
pg_ctl -D $D/n -w -l $D/log start >/dev/null 2>&1
psql -X -q -d postgres -c "create table t(a int); insert into t values (1);"
pg_basebackup -D $D/b1 --no-sync -c fast && echo full ok
psql -X -q -d postgres -c "alter system set wal_level=minimal" -c "alter system set max_wal_senders=0" -c "alter system set summarize_wal=off"
pg_ctl -D $D/n -w -l $D/log restart >/dev/null 2>&1
psql -X -q -d postgres -c "insert into t values (2)"
psql -X -q -d postgres -c "alter system reset wal_level" -c "alter system reset max_wal_senders" -c "alter system reset summarize_wal"
pg_ctl -D $D/n -w -l $D/log restart >/dev/null 2>&1
if pg_basebackup -D $D/b2 --no-sync -c fast -i $D/b1/backup_manifest >/dev/null 2>&1; then echo incremental succeeded; else echo incremental failed; fi
pg_ctl -D $D/n -m immediate stop >/dev/null 2>&1
rm -rf $D
