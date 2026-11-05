D=$PWD/rtmp_cluster
rm -rf $D
initdb -D $D >/dev/null 2>&1
SOCK=$PWD/rtmp_sock; rm -rf $SOCK; mkdir -p $SOCK
pg_ctl -D $D -o "-c max_prepared_transactions=5 -c listen_addresses='' -c unix_socket_directories=$SOCK" -w -l $D/log start >/dev/null 2>&1
export PGHOST=$SOCK
psql -X -a -q -d postgres <<'SQL' 2>&1
BEGIN;
SELECT pg_advisory_lock(1);
SELECT pg_advisory_xact_lock_shared(1);
PREPARE TRANSACTION 'foo';
ROLLBACK;
SELECT 1 AS still_alive;
SQL
pg_ctl -D $D -m immediate stop >/dev/null 2>&1
rm -rf $D $SOCK
