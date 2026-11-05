D=$PWD/rc_data; S=$PWD/rc_sock
rm -rf $D $S; mkdir -p $S
initdb -D $D >/dev/null 2>&1
echo "track_commit_timestamp = on" >> $D/postgresql.conf
O="-c listen_addresses= -c unix_socket_directories=$S"
pg_ctl -D $D -w -l $D/log -o "$O" start >/dev/null 2>&1
pg_ctl -D $D -m fast -w stop >/dev/null
echo "track_commit_timestamp = off" >> $D/postgresql.conf
pg_ctl -D $D -w -l $D/log -o "$O" start >/dev/null 2>&1
pg_ctl -D $D -m fast -w restart >/dev/null 2>&1
psql -X -h $S -d postgres -qc "CREATE PROCEDURE c(cnt int) AS \$\$ BEGIN FOR i in 1..cnt LOOP EXECUTE 'CREATE TEMP TABLE IF NOT EXISTS t(a int)'; EXECUTE 'INSERT INTO t VALUES (1)'; COMMIT; END LOOP; END; \$\$ LANGUAGE plpgsql" -c "CALL c(2000)"
echo "track_commit_timestamp = on" >> $D/postgresql.conf
pg_ctl -D $D -m immediate -w stop >/dev/null
if pg_ctl -D $D -w -l $D/log -o "$O" start >/dev/null 2>&1; then echo restart ok; else echo restart failed; fi
pg_ctl -D $D -m immediate stop >/dev/null 2>&1
rm -rf $D $S
