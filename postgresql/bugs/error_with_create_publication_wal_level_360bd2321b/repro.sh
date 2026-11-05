D=$PWD/tmp_minimal
rm -rf $D
initdb -D $D >/dev/null 2>&1
S=$PWD/tmp_sock; rm -rf $S; mkdir -p $S
pg_ctl -D $D -o "-c wal_level=minimal -c max_wal_senders=0 -c listen_addresses='' -c unix_socket_directories=$S" -w -l $D/log start >/dev/null
psql -X -a -q -h $S -d postgres <<'SQL' 2>&1
BEGIN;
CREATE TABLE skip_wal();
CREATE PUBLICATION tap_pub2 FOR TABLE skip_wal;
ROLLBACK;
SQL
pg_ctl -D $D -m fast stop >/dev/null
rm -rf $D $S
