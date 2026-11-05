set -e
D=$PWD/rtmp; rm -rf $D; mkdir $D
psql -X -q -c "alter system set summarize_wal=on" -c "select pg_reload_conf()" >/dev/null
sleep 1
psql -X -q -c "CREATE DATABASE lakh OID = 100000 STRATEGY = FILE_COPY"
psql -X -q -d lakh -c "CREATE TABLE t1 (a int)"
pg_basebackup -D $D/b1 --no-sync --checkpoint fast
psql -X -q -c "DROP DATABASE lakh" -c "CREATE DATABASE lakh OID = 100000 STRATEGY = FILE_COPY"
pg_basebackup -D $D/b2 --no-sync --checkpoint fast --incremental $D/b1/backup_manifest
pg_combinebackup -o $D/r $D/b1 $D/b2 --no-sync
mkdir $D/sock
pg_ctl -D $D/r -o "-c unix_socket_directories=$D/sock -c listen_addresses='' -c port=54999 -c summarize_wal=off -c archive_mode=off" -w -l $D/log start >/dev/null
psql -X -h $D/sock -p 54999 -d lakh -c "SELECT * FROM t1" 2>&1 | sed 's/".*"/"X"/' || true
pg_ctl -D $D/r -m immediate stop >/dev/null
rm -rf $D
