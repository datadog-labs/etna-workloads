psql -X -q -c "ALTER SYSTEM SET wal_level = logical"
pg_ctl -w -t 60 -l "$PGDATA/restart.log" restart >/dev/null 2>&1
psql -X -a -q <<'SQL'
CREATE TABLE t(id int primary key);
INSERT INTO t VALUES (1);
CREATE PUBLICATION p FOR TABLE t;
SELECT 'init' FROM pg_create_logical_replication_slot('s','pgoutput',false,true);
BEGIN;
SELECT * FROM t WHERE id=1 FOR SHARE;
PREPARE TRANSACTION 'e1';
COMMIT PREPARED 'e1';
BEGIN;
SELECT * FROM t WHERE id=1 FOR SHARE;
PREPARE TRANSACTION 'e2';
ROLLBACK PREPARED 'e2';
SELECT chr(get_byte(data,0)) AS msgtype FROM pg_logical_slot_get_binary_changes('s',NULL,NULL,'proto_version','3','publication_names','p','two_phase','on');
SQL
