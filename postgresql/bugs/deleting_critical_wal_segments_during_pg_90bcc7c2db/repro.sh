set -e
D=$PWD/rw_tmp; rm -rf $D; mkdir $D
export PGHOST=$D PGPORT=54399
initdb -D $D/p -A trust >/dev/null
cat >> $D/p/postgresql.conf <<C
listen_addresses=''
unix_socket_directories='$D'
port=$PGPORT
wal_level=replica
archive_mode=on
archive_command='false'
max_wal_senders=5
wal_log_hints=on
wal_keep_size=0
max_wal_size=1GB
min_wal_size=32MB
C
echo "host replication all 127.0.0.1/32 trust" >/dev/null
pg_ctl -D $D/p -w -l $D/p.log start >/dev/null
pg_basebackup -D $D/s -X stream -R >/dev/null 2>&1
sed -i 's/^archive_mode.*/archive_mode=off/;s/^port=.*/port=54398/' $D/s/postgresql.conf
echo "port=54398" >> $D/s/postgresql.conf
pg_ctl -D $D/s -w -l $D/s.log start >/dev/null
psql -X -qc "create table t(a int)" postgres
psql -X -qc checkpoint postgres
sleep 2
PGPORT=54398 psql -X -qc checkpoint postgres
for i in 1 2 3 4; do psql -X -qAtc "select pg_switch_wal(); insert into t values(1)" postgres >/dev/null; done
psql -X -qc "select pg_switch_wal()" postgres >/dev/null
sleep 2
pg_ctl -D $D/s promote -w >/dev/null
PGPORT=54398 psql -X -qc checkpoint postgres
PGPORT=54398 psql -X -qc "checkpoint" postgres
pg_ctl -D $D/p -m fast stop >/dev/null
pg_rewind -n --debug --source-server="port=54398 host=$D dbname=postgres" --target-pgdata=$D/p 2>&1 | grep "Not removing" | sort || true
pg_ctl -D $D/s -m immediate stop >/dev/null
