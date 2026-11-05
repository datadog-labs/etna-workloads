D=$PWD/rdata_$$
initdb -D $D >/dev/null 2>&1
S=$D/sock; mkdir -p $S
pg_ctl -D $D -o "-c wal_level=logical -c listen_addresses='' -c unix_socket_directories=$S" -l $D/log -w start >/dev/null
export PGHOST=$S PGPORT=5432 PGDATABASE=postgres
psql -X -a -q <<'SQL'
CREATE TABLE tab4 (a int PRIMARY KEY) PARTITION BY LIST (a);
CREATE TABLE tab4_1 PARTITION OF tab4 FOR VALUES IN (0,1) PARTITION BY LIST (a);
CREATE TABLE tab4_1_1 PARTITION OF tab4_1 FOR VALUES IN (0,1);
CREATE PUBLICATION pub_all FOR ALL TABLES WITH (publish_via_partition_root = true);
CREATE PUBLICATION pub_lower FOR TABLE tab4_1 WITH (publish_via_partition_root = true);
SELECT pg_create_logical_replication_slot('s','pgoutput');
INSERT INTO tab4 VALUES (1);
SELECT position('tab4_1'::bytea in data) > 0 AS via_middle
FROM pg_logical_slot_get_binary_changes('s', NULL, NULL, 'proto_version','1','publication_names','pub_all,pub_lower')
WHERE get_byte(data,0) = 82;
SQL
pg_ctl -D $D -m immediate stop >/dev/null
rm -rf $D
