P="psql -X -q"
$P <<'SQL'
create table tpart(i int, j text) partition by range(i);
create table tpart_1(like tpart);
create table tpart_2(like tpart);
create table tpart_default (a int, j text, i int) partition by list (j);
create table tpart_default_default (a int, i int, b int, j text);
alter table tpart_default_default drop b;
alter table tpart_default attach partition tpart_default_default default;
alter table tpart_default drop a;
alter table tpart attach partition tpart_default default;
alter table tpart attach partition tpart_1 for values from(0) to (100);
insert into tpart_2 values (110,'xxx'), (120, 'yyy'), (150, 'zzz');
SQL
( echo "begin; alter table tpart attach partition tpart_2 for values from (100) to (200); select pg_sleep(3); commit;" | $P >/dev/null 2>&1 ) &
sleep 1
$P -c "insert into tpart values (110,'xxx'), (120, 'yyy'), (150, 'zzz');" 2>&1
wait
$P -c "select tableoid::regclass, * from tpart order by 1,2"
