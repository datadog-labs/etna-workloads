D=$PWD/rtmp; rm -rf $D; mkdir -p $D
for n in pub sub; do
initdb -D $D/$n >/dev/null 2>&1
done
echo "wal_level=logical
listen_addresses=''
unix_socket_directories='$D'" > $D/pub/postgresql.auto.conf
cp $D/pub/postgresql.auto.conf $D/sub/postgresql.auto.conf
echo "port=5501" >> $D/pub/postgresql.auto.conf
echo "port=5502" >> $D/sub/postgresql.auto.conf
pg_ctl -D $D/pub -w -l $D/pub.log start >/dev/null
pg_ctl -D $D/sub -w -l $D/sub.log start >/dev/null
P="psql -X -q -h $D -d postgres"
$P -p 5501 -c "CREATE FUNCTION public.pg_get_replica_identity_index(int) RETURNS regclass LANGUAGE sql AS 'SELECT 1/0'" -c "CREATE TABLE t(a int primary key)" -c "INSERT INTO t VALUES (1),(2)" -c "CREATE PUBLICATION p FOR TABLE t"
$P -p 5502 -c "CREATE TABLE t(a int primary key)" -c "CREATE SUBSCRIPTION s CONNECTION 'host=$D port=5501 dbname=postgres' PUBLICATION p"
i=0; while [ $i -lt 20 ]; do
 r=$($P -p 5502 -At -c "select count(*) from t"); [ "$r" = 2 ] && break; i=$((i+1)); sleep 1; done
echo "rows on subscriber: $r"
$P -p 5502 -c "DROP SUBSCRIPTION s" >/dev/null 2>&1
pg_ctl -D $D/sub -m immediate stop >/dev/null; pg_ctl -D $D/pub -m immediate stop >/dev/null
rm -rf $D
