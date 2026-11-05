D=$PWD/subtmp; rm -rf $D; mkdir $D
initdb -D $D/sub >/dev/null 2>&1
echo "unix_socket_directories='$D'
listen_addresses=''
port=5499" >> $D/sub/postgresql.conf
pg_ctl -D $D/sub -l $D/sub.log -w start >/dev/null
S="psql -X -q -h $D -p 5499 -d postgres"
psql -X -q -c "alter system set wal_level=logical"
pg_ctl -D $PGDATA -l $D/pub.log -w restart >/dev/null
psql -X -q -c "create table t(id int primary key, junk text, bid int); create publication p for table t;"
$S -c "create table t(id int primary key, bid int, junk text);
create table log(m text);
create function f() returns trigger language plpgsql as \$\$ begin insert into public.log values('fired'); return new; end \$\$;
create trigger tr before update of bid on t for each row execute function f();
alter table t enable always trigger tr;"
psql -X -q -c "insert into t values (1, (select string_agg(md5(i::text),'') from generate_series(1,3000) i), 1)"
$S -c "create subscription s connection 'host=$PGHOST port=$PGPORT dbname=postgres' publication p" >/dev/null 2>&1
W() { for i in $(seq 150); do [ "$($S -Atc "$1")" = t ] && return; sleep 0.2; done; }
W "select count(*)=1 from t"
psql -X -q -c "update t set bid=2 where id=1"
W "select bool_or(bid=2) from t"
sleep 1
$S -c "select id,bid from t; select * from log"
$S -c "drop subscription s" >/dev/null 2>&1
pg_ctl -D $D/sub -m immediate stop >/dev/null
