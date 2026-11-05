D=$PWD/rc_data; S=$PWD/rc_sock
rm -rf $D $S; mkdir -p $S
initdb -D $D >/dev/null 2>&1
echo "autovacuum_naptime=1s
listen_addresses=''
unix_socket_directories='$S'" >> $D/postgresql.conf
pg_ctl -D $D -w -l $D/log start >/dev/null 2>&1
q() { psql -X -q -t -A -h $S -d postgres "$@"; }
q -c "create table journal (d timestamp) with (fillfactor = 10);
create function packdate(d timestamp) returns text language plpgsql as \$\$ begin return to_char(d, 'yyyymm'); end; \$\$ returns null on null input immutable;
create index brin_packdate_idx on journal using brin (packdate(d)) with (autosummarize = on, pages_per_range = 1);
insert into journal select * from generate_series(timestamp '1976-08-01', '1976-10-28', '1 day');" >/dev/null
i=0
while [ $i -lt 15 ]; do
  b=$(q -c "set enable_seqscan=off; explain (analyze, costs off, timing off, summary off) select * from journal where packdate(d) = '197608'" | grep -o 'Removed by Index Recheck: [0-9]*' | cut -d: -f2)
  p=$(q -c "select relpages from pg_class where relname='journal'")
  [ -n "$b" ] && [ "$b" -lt 20 ] && r=t && break
  sleep 1; i=$((i+1))
done
echo "ranges skipped by index: ${r:-f}"
pg_ctl -D $D -m fast stop >/dev/null 2>&1
rm -rf $D $S
