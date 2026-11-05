D=$PWD/crashdata
rm -rf $D
initdb -D $D >/dev/null 2>&1
S=$PWD/sock; rm -rf $S; mkdir $S
O="-c listen_addresses= -c unix_socket_directories=$S"
pg_ctl -D $D -o "$O" -w -l $D/log start >/dev/null
pg_ctl -D $D -m immediate -w stop >/dev/null
pg_ctl -D $D -o "$O" -w -l $D/log start >/dev/null
psql -X -h $S -d postgres -At -c "select stats_reset is not null as wal_reset_set from pg_stat_wal" -c "select stats_reset is not null as bgwriter_reset_set from pg_stat_bgwriter"
pg_ctl -D $D -m fast -w stop >/dev/null
rm -rf $D $S
