D=$PWD/tmp_repro; rm -rf $D; mkdir -p $D
P=$D/p; S=$D/s
initdb -D $P >/dev/null
echo "unix_socket_directories='$D'
listen_addresses=''
port=54329" >> $P/postgresql.conf
pg_ctl -D $P -l $D/p.log -w start >/dev/null
psql -X -q -h $D -p 54329 -d postgres -c "create database rl"
pg_basebackup -h $D -p 54329 -D $S -R >/dev/null 2>&1
echo "port=54330" >> $S/postgresql.conf
pg_ctl -D $S -l $D/s.log -w start >/dev/null
psql -X -q -h $D -p 54329 -d rl <<'SQL'
create function f() returns event_trigger language plpgsql as $$ begin end $$;
create event trigger t on login execute function f();
alter event trigger t enable always;
drop event trigger t;
drop function f();
SQL
LSN=$(psql -X -At -h $D -p 54329 -d postgres -c "select pg_current_wal_lsn()")
for i in $(seq 100); do
  [ "$(psql -X -At -h $D -p 54330 -d postgres -c "select pg_last_wal_replay_lsn() >= '$LSN'")" = t ] && break
  sleep 0.2
done
psql -X -At -h $D -p 54330 -d rl -c "select 'standby connect ok'" 2>&1 | sed 's/^psql: error.*/connect failed/;s/^FATAL.*/connect failed/'
pg_ctl -D $S -m immediate stop >/dev/null
pg_ctl -D $P -m immediate stop >/dev/null
rm -rf $D
