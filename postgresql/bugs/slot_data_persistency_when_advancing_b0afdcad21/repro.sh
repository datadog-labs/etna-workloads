psql -X -q -At <<'S'
SELECT slot_name FROM pg_create_physical_replication_slot('s', true);
CREATE TABLE t(a int);
INSERT INTO t SELECT generate_series(1,10);
SELECT pg_switch_wal() IS NOT NULL;
SELECT slot_name FROM pg_replication_slot_advance('s', pg_current_wal_lsn());
CREATE TEMP TABLE pre AS SELECT restart_lsn FROM pg_replication_slots WHERE slot_name='s';
\! echo "$(psql -X -At -c "select restart_lsn from pg_replication_slots where slot_name='s'")" > pre.txt
S
pg_ctl -D "$PGDATA" -w -m fast restart >/dev/null 2>&1
post=$(psql -X -At -c "select restart_lsn from pg_replication_slots where slot_name='s'")
[ "$post" = "$(cat pre.txt)" ] && echo "persisted" || echo "lost"
rm -f pre.txt
