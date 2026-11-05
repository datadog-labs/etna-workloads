psql -X -qc "alter system set wal_level = logical"
pg_ctl restart -w -l "$PWD/rs.log" >/dev/null
psql -X -qc "create table t(a int); create publication p for table t"
pg_recvlogical -d postgres --slot s1 --create-slot -P pgoutput
psql -X -qc "insert into t values (1)"
pg_recvlogical -d postgres --slot s1 --start -o proto_version=1 -o publication_names=p -f /dev/null &
RP=$!
sleep 4
psql -X -Atc "select state from pg_stat_replication"
kill $RP
wait $RP 2>/dev/null
