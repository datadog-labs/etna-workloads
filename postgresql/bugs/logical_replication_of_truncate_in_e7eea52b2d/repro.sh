D=$PWD/rtmp; rm -rf $D; mkdir -p $D
S=$D/sock
initdb -D $D/pub -A trust >/dev/null 2>&1
initdb -D $D/sub -A trust >/dev/null 2>&1
cat >> $D/pub/postgresql.conf <<EOC
wal_level=logical
port=54871
unix_socket_directories='$D'
listen_addresses=''
EOC
cat >> $D/sub/postgresql.conf <<EOC
port=54872
unix_socket_directories='$D'
listen_addresses=''
max_logical_replication_workers=4
EOC
pg_ctl -D $D/pub -w -l $D/pub.log start >/dev/null
pg_ctl -D $D/sub -w -l $D/sub.log start >/dev/null
P="psql -X -q -h $D -p 54871 -d postgres"
B="psql -X -q -h $D -p 54872 -d postgres"
$P -c "create table t(a int primary key)" -c "create publication pb for table t"
$B -c "create table t(a int primary key)"
$B -c "create subscription sb connection 'host=$D port=54871 dbname=postgres application_name=sb' publication pb"
sleep 5
$P -c "alter system set synchronous_standby_names='sb'" -c "select pg_reload_conf()" >/dev/null
sleep 1
$P -c "insert into t values (1)"
timeout 20 $P -c "truncate t" ; echo "truncate exit: $?"
$P -c "alter system reset synchronous_standby_names" -c "select pg_reload_conf()" >/dev/null
pg_ctl -D $D/sub -m immediate stop >/dev/null
pg_ctl -D $D/pub -m immediate stop >/dev/null
rm -rf $D
