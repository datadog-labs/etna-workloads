D=$PWD/sub_data
P2=$((PGPORT+1))
rm -rf $D
initdb -D $D >/dev/null 2>&1
pg_ctl -D $D -o "-p $P2 -c unix_socket_directories=$PGHOST -c listen_addresses=''" -l $D/log -w start >/dev/null
S="psql -X -q -At -p $P2"
P="psql -X -q -At"
$P -c "alter system set wal_level=logical" >/dev/null
pg_ctl -D $PGDATA -m fast -w restart >/dev/null
$P -c "create table tab5 (a int primary key, b int); insert into tab5 values (1,1); create publication pub for table tab5;"
$S -c "create table tab5 (a int, b int, c int) partition by list (a); create table tab5_1 (c int, b int, a int primary key); alter table tab5 attach partition tab5_1 for values in (1,2,3);" >/dev/null
$S -c "create subscription sub connection 'port=$PGPORT host=$PGHOST dbname=postgres' publication pub;" >/dev/null
sleep 3
$P -c "update tab5 set b=2 where a=1;" >/dev/null
sleep 2
$P -c "alter table tab5 drop column b, add column c int; alter table tab5 add column b int; update tab5 set c=7 where a=1;" >/dev/null
sleep 3
$S -c "select a,b,c from tab5 order by 1"
$S -c "alter subscription sub disable; alter subscription sub set (slot_name=none); drop subscription sub" >/dev/null
pg_ctl -D $D -m immediate stop >/dev/null
