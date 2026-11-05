D=$PWD/rw_tmp
rm -rf $D; mkdir $D
initdb -D $D/a >/dev/null 2>&1
cat >> $D/a/postgresql.conf <<C
listen_addresses=''
unix_socket_directories='$D'
port=54399
wal_log_hints=on
C
echo "local replication all trust" > $D/a/pg_hba.conf
pg_ctl -D $D/a -l $D/a.log -w start >/dev/null
pg_ctl -D $D/a -m fast -w stop >/dev/null
cp -r $D/a $D/b
pg_rewind --target-pgdata=$D/a --source-pgdata=$D/b 2>&1
echo "exit: $?"
rm -rf $D
