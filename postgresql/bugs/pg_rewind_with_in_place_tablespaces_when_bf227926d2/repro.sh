D=$PWD/rw_tmp; rm -rf $D; mkdir -p $D/sock
O="-c listen_addresses='' -c unix_socket_directories=$D/sock -c allow_in_place_tablespaces=on -c wal_log_hints=on -c wal_keep_size=100MB -c max_wal_senders=5 -c wal_level=replica"
initdb -D $D/a >/dev/null 2>&1
pg_ctl -D $D/a -o "$O -p 5499" -l $D/a.log -w start >/dev/null
psql -X -q -h $D/sock -p 5499 postgres -c "CREATE TABLESPACE sp LOCATION ''" -c "CREATE TABLE t (d text) TABLESPACE sp" -c "INSERT INTO t VALUES ('before')"
pg_basebackup -h $D/sock -p 5499 -D $D/b -X stream -R >/dev/null 2>&1
pg_ctl -D $D/b -o "$O -p 5498" -l $D/b.log -w start >/dev/null
pg_ctl -D $D/b -w promote >/dev/null
psql -X -q -h $D/sock -p 5499 postgres -c "INSERT INTO t VALUES ('a-after')"
pg_ctl -D $D/a -m fast -w stop >/dev/null
psql -X -q -h $D/sock -p 5498 postgres -c "INSERT INTO t VALUES ('b-after')"
pg_rewind -D $D/a --source-server="host=$D/sock port=5498 dbname=postgres" 2>&1 | grep -E "error|Done"
pg_ctl -D $D/b -m fast -w stop >/dev/null
rm -rf $D
