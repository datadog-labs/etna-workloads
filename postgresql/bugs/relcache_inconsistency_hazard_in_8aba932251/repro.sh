P="psql -X -a -q"
$P -c "create table d4_primary (a int primary key) partition by list (a);
create table d4_primary1 partition of d4_primary for values in (1);
create table d4_primary2 partition of d4_primary for values in (2);
insert into d4_primary values (1),(2);
create table d4_fk (a int references d4_primary);
insert into d4_fk values (2);" 2>&1
rm -f s1.fifo; mkfifo s1.fifo
$P -f s1.fifo > s1.out 2>&1 &
exec 3>s1.fifo
echo "begin isolation level repeatable read; select * from d4_primary;" >&3
sleep 1
PGOPTIONS="-c statement_timeout=1000" $P -c "alter table d4_primary detach partition d4_primary1 concurrently" 2>&1 | grep -v '^$'
$P -c "vacuum freeze pg_catalog.pg_inherits" 2>&1
echo "select * from d4_primary;" >&3
echo "insert into d4_fk values (1);" >&3
echo "commit;" >&3
exec 3>&-
wait
cat s1.out
