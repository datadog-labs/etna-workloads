pg_ctl -w -m fast stop >/dev/null 2>&1
echo "wal_level = logical" >> "$PGDATA/postgresql.conf"
pg_ctl -w -l "$PGDATA/log2" start >/dev/null 2>&1
psql -X -a -q <<'S'
CREATE TABLE t (a int PRIMARY KEY, b int, c int);
CREATE PUBLICATION p FOR TABLE t (a, b);
INSERT INTO t VALUES (1,2,3);
SELECT slot_name FROM pg_create_logical_replication_slot('s','pgoutput');
UPDATE t SET a = 2;
DELETE FROM t;
SELECT get_byte(data,0) AS typ, substr(data,7,2) = int2send(2::smallint) AS two_cols
FROM pg_logical_slot_peek_binary_changes('s',NULL,NULL,'proto_version','1','publication_names','p')
WHERE get_byte(data,0) IN (85,68);
S
