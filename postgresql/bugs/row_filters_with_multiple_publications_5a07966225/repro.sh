D=$PWD/rtmp_cluster
rm -rf $D; mkdir -p $D
initdb -D $D/data -A trust >/dev/null 2>&1
pg_ctl -D $D/data -o "-c wal_level=logical -c listen_addresses='' -k $D" -l $D/log -w start >/dev/null 2>&1
P="psql -X -a -q -h $D -d postgres"
$P <<'SQL'
CREATE TABLE p (a int) PARTITION BY RANGE (a);
CREATE TABLE p1 PARTITION OF p FOR VALUES FROM (1) TO (20);
CREATE PUBLICATION pub1 FOR TABLE p WHERE (a > 15) WITH (publish_via_partition_root);
CREATE PUBLICATION pub2 FOR TABLE p1 WHERE (a < 15) WITH (publish_via_partition_root);
SELECT 1 FROM pg_create_logical_replication_slot('s','pgoutput');
INSERT INTO p VALUES (14),(15),(16);
SELECT count(*) AS inserts_replicated FROM pg_logical_slot_get_binary_changes('s',NULL,NULL,'proto_version','1','publication_names','pub1,pub2') WHERE get_byte(data,0)=73;
SQL
pg_ctl -D $D/data -m immediate stop >/dev/null 2>&1
rm -rf $D
