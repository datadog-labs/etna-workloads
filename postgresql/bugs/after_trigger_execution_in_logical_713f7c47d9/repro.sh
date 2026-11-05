P="psql -X -q -At"
$P -d postgres -c "alter system set wal_level = logical"
pg_ctl -w -t 60 -l "$PGDATA/restart.log" restart >/dev/null
$P -d postgres -c "create database pubdb" -c "create database subdb"
$P -d pubdb -c "create table t(id int primary key)" -c "create publication p for table t"
$P -d pubdb -c "select 1 from pg_create_logical_replication_slot('s','pgoutput')" >/dev/null
$P -d subdb <<SQL
create table t(id int primary key);
create table log(msg text);
create function f() returns trigger language plpgsql as \$\$ begin insert into public.log values (tg_op||' '||new.id); return null; end \$\$;
create trigger tr after insert on t for each row execute procedure f();
alter table t enable always trigger tr;
create subscription sb connection 'port=$PGPORT host=$PGHOST dbname=pubdb' publication p with (create_slot=false, slot_name='s', copy_data=false);
SQL
$P -d pubdb -c "insert into t values (1)"
for i in $(seq 100); do
  n=$($P -d subdb -c "select count(*) from t")
  [ "$n" = 1 ] && break; sleep 0.2
done
echo "rows: $n"
for i in $(seq 25); do
  [ "$($P -d subdb -c 'select count(*) from log')" = 1 ] && break; sleep 0.2
done
$P -d subdb -c "select * from log"
