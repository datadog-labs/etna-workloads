D=$PWD/tmp_repro_data
rm -rf $D
initdb -D $D >/dev/null 2>&1
S=$PWD/tmp_repro_sock; rm -rf $S; mkdir $S
pg_ctl -D $D -o "-c wal_level=logical -c listen_addresses='' -c unix_socket_directories=$S" -l $D/log -w start >/dev/null
export PGHOST=$S PGPORT=5432 PGDATABASE=postgres
psql -X -a -q <<'SQL'
CREATE TABLE root (a int, b text) PARTITION BY LIST (a);
CREATE TABLE p1 (b text, a int);
ALTER TABLE root ATTACH PARTITION p1 FOR VALUES IN (1, 2, 3);
CREATE PUBLICATION pub FOR TABLE root WITH (publish_via_partition_root = true);
SELECT 1 FROM pg_create_logical_replication_slot('s', 'pgoutput');
INSERT INTO root VALUES (1, 'x');
ALTER PUBLICATION pub SET (publish_via_partition_root = false);
INSERT INTO root VALUES (2, 'y');
SELECT length(data) AS len, get_byte(data,0) AS kind FROM pg_logical_slot_get_binary_changes('s', NULL, NULL, 'proto_version', '1', 'publication_names', 'pub') WHERE get_byte(data,0) IN (73,82);
SQL
pg_ctl -D $D -m immediate stop >/dev/null 2>&1
rm -rf $D $S
