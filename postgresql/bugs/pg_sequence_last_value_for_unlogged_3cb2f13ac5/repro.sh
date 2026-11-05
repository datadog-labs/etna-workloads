D=$PWD/sb_tmp
rm -rf "$D"; mkdir "$D"
psql -X -q -c "ALTER SYSTEM SET wal_level=replica" >/dev/null 2>&1
psql -X -q -c "CREATE UNLOGGED SEQUENCE useq" -c "SELECT nextval('useq')" -c "CHECKPOINT" >/dev/null
pg_basebackup -D "$D/data" -Fp -X stream -c fast -h "$PGHOST" -p "$PGPORT" >/dev/null 2>&1
touch "$D/data/standby.signal"
pg_ctl -D "$D/data" -o "-p 54999 -k $D -c listen_addresses='' -c hot_standby=on" -l "$D/log" -w start >/dev/null 2>&1
psql -X -q -h "$D" -p 54999 -c "SELECT pg_is_in_recovery()" -c "SELECT pg_sequence_last_value('useq'::regclass)" 2>&1 | sed 's/^psql:.*ERROR: *//'
pg_ctl -D "$D/data" -m immediate stop >/dev/null 2>&1
rm -rf "$D"
