D=$PWD/rtmp_data; S=$PWD/rtmp_sock
rm -rf $D $S; mkdir -p $S
initdb -D $D >/dev/null 2>&1
pg_ctl -D $D -o "-c wal_level=logical -c listen_addresses='' -k $S -p 5499" -l $PWD/rtmp.log -w start >/dev/null
export PGHOST=$S PGPORT=5499
psql -X -a -q -d postgres <<'SQL'
CREATE TABLE tab_nothing (a int);
ALTER TABLE tab_nothing REPLICA IDENTITY NOTHING;
CREATE PUBLICATION p FOR TABLE tab_nothing;
SELECT 1 FROM pg_create_logical_replication_slot('s','pgoutput');
INSERT INTO tab_nothing VALUES (1);
SELECT count(*) > 0 AS got_changes FROM pg_logical_slot_get_binary_changes('s', NULL, NULL, 'proto_version', '1', 'publication_names', 'p');
SQL
pg_ctl -D $D -m immediate stop >/dev/null 2>&1
rm -rf $D $S
