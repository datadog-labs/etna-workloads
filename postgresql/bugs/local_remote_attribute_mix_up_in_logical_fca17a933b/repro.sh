D=$PWD/rtmp; rm -rf $D; mkdir -p $D
PP=54873; SP=54874
for n in pub sub; do
  initdb -D $D/$n >/dev/null 2>&1
done
pg_ctl -D $D/pub -o "-c listen_addresses='' -c unix_socket_directories=$D -p $PP -c wal_level=logical" -w -l $D/pub.log start >/dev/null
pg_ctl -D $D/sub -o "-c listen_addresses='' -c unix_socket_directories=$D -p $SP" -w -l $D/sub.log start >/dev/null
psql -X -q -h $D -p $PP postgres <<SQL
create table t(a int primary key, b text);
insert into t values (1,'foo');
create publication p for table t;
SQL
psql -X -q -h $D -p $SP postgres <<SQL
create table t(c text, b text, a int primary key);
create subscription s connection 'host=$D port=$PP dbname=postgres' publication p;
SQL
sleep 4
psql -X -q -h $D -p $PP postgres -c "update t set b='bar' where a=1"
sleep 4
psql -X -h $D -p $SP postgres -c "select c,b,a from t"
psql -X -q -h $D -p $SP postgres -c "drop subscription s"
pg_ctl -D $D/sub -m immediate stop >/dev/null
pg_ctl -D $D/pub -m immediate stop >/dev/null
rm -rf $D
