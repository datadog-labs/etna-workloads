D=$PWD/rtmp; rm -rf $D; mkdir -p $D/ts
export PGHOST=$D PGPORT=5499 PGDATABASE=postgres
initdb -D $D/data >/dev/null 2>&1
O="-c wal_level=minimal -c max_wal_senders=0 -c wal_skip_threshold=0 -c unix_socket_directories=$D -c listen_addresses= -c port=5499 -c checkpoint_timeout=1h"
pg_ctl -D $D/data -o "$O" -l $D/log -w start >/dev/null
psql -X -q -a <<SQL
CREATE TABLE moved (id int);
INSERT INTO moved VALUES (1);
CREATE TABLESPACE other LOCATION '$D/ts';
BEGIN;
ALTER TABLE moved SET TABLESPACE other;
COMMIT;
SQL
pg_ctl -D $D/data -m immediate -w stop >/dev/null
pg_ctl -D $D/data -o "$O" -l $D/log -w start >/dev/null
psql -X -At -c "SELECT count(*) FROM moved;"
pg_ctl -D $D/data -m immediate -w stop >/dev/null
rm -rf $D
