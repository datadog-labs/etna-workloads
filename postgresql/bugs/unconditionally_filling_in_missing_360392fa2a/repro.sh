D=$PWD/tmp_cl
rm -rf $D
initdb -D $D >/dev/null
P=$(( 20000 + $$ % 20000 ))
pg_ctl -D $D -o "-c wal_level=logical -c listen_addresses='' -c unix_socket_directories=$D -c port=$P" -l $D/log -w start >/dev/null
q() { psql -X -a -q -h $D -p $P postgres; }
q <<'SQL'
CREATE TABLE t (a int);
ALTER TABLE t REPLICA IDENTITY FULL;
INSERT INTO t VALUES (1);
ALTER TABLE t ADD COLUMN b bool DEFAULT false NOT NULL;
CREATE PUBLICATION pub FOR TABLE t;
SELECT 1 FROM pg_create_logical_replication_slot('s','pgoutput');
UPDATE t SET a = a + 1;
SELECT get_byte(data,0) = 85 AS is_update, position('\x4b'::bytea in data) > 0 AS has_old,
  encode(substring(data from 8),'hex') AS tuples
FROM pg_logical_slot_get_binary_changes('s', NULL, NULL, 'proto_version','1','publication_names','pub')
WHERE get_byte(data,0)=85;
SQL
pg_ctl -D $D -m immediate stop >/dev/null
rm -rf $D
