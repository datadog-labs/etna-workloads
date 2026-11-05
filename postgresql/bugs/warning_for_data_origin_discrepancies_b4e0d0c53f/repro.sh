D=$PWD/tmp_repro; rm -rf $D; mkdir $D
for n in a b; do
initdb -D $D/$n >/dev/null 2>&1
echo "wal_level=logical
port=5441$([ $n = b ] && echo 1 || echo 0)
unix_socket_directories='$D'
listen_addresses=''" >> $D/$n/postgresql.conf
pg_ctl -D $D/$n -l $D/$n.log -w start >/dev/null
done
A="psql -X -q -h $D -p 54410 postgres"; B="psql -X -q -h $D -p 54411 postgres"
$A -c "create table tab_part2(a int); create publication pa for table tab_part2;"
$B -c "create table tab_main(a int) partition by range(a);
create table tab_part2(a int) partition by range(a);
create table tab_part2_1 partition of tab_part2 for values from (5) to (10);
alter table tab_main attach partition tab_part2 for values from (5) to (10);
create publication pb for table tab_main;" 2>&1
$B -c "create subscription sb connection 'host=$D port=54410 dbname=postgres' publication pa;" 2>&1 | grep -v NOTICE
sleep 2
$A -c "create table tab_main(a int); create table tab_part2_1(a int);"
$A -c "create subscription sa connection 'host=$D port=54411 dbname=postgres' publication pb with (origin=none, copy_data=true);" 2>&1 | grep -v NOTICE
$A -c "drop subscription sa" >/dev/null 2>&1
$B -c "drop subscription sb" >/dev/null 2>&1
for n in a b; do pg_ctl -D $D/$n -m immediate stop >/dev/null; done
rm -rf $D
