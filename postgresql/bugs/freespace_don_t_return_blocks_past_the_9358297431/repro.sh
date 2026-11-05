D=$PWD/rtmp; rm -rf $D; mkdir -p $D
S=$D/s; P2=54329
cat >> $PGDATA/postgresql.conf <<C
wal_log_hints = on
max_prepared_transactions = 5
autovacuum = off
wal_level = replica
max_wal_senders = 5
C
pg_ctl -D $PGDATA -w -l $D/p.log restart >/dev/null 2>&1
pg_basebackup -D $S -Fp -X stream -R -d "host=$PGHOST port=$PGPORT dbname=postgres" >$D/bb.log 2>&1
cat >> $S/postgresql.conf <<C
port = $P2
unix_socket_directories = '$D'
C
pg_ctl -D $S -w -l $D/s.log start >/dev/null 2>&1
q() ( psql -X -q -h $PGHOST -p $PGPORT postgres -c "$1" >/dev/null 2>&1 )
s() ( psql -X -q -h $D -p $P2 postgres -c "$1" 2>&1 )
q "create table testtab (a int, b char(100)); insert into testtab select generate_series(1,1000), 'foo'; insert into testtab select generate_series(1,1000), 'foo'; delete from testtab where ctid > '(8,0)';"
q "begin; lock table testtab in row share mode; prepare transaction 'p1';"
q "vacuum testtab"
q "checkpoint"
q "insert into testtab select generate_series(1,1000), 'foo'; delete from testtab where ctid > '(8,0)'"
q "vacuum testtab"
s "checkpoint" >/dev/null
q "rollback prepared 'p1'"
q "vacuum testtab"
q "checkpoint"
L=$(psql -X -At -h $PGHOST -p $PGPORT postgres -c "select pg_current_wal_lsn()")
for i in $(seq 100); do
  [ "$(psql -X -At -h $D -p $P2 postgres -c "select '$L'::pg_lsn <= pg_last_wal_replay_lsn()")" = t ] && break
  sleep 0.2
done
pg_ctl -D $S -w promote >/dev/null 2>&1
s "checkpoint" >/dev/null
pg_ctl -D $S -w -l $D/s.log restart >/dev/null 2>&1
s "insert into testtab select generate_series(1,1000), 'foo';" | grep -o 'ERROR.*' | head -1
echo done
pg_ctl -D $S -m immediate stop >/dev/null 2>&1
