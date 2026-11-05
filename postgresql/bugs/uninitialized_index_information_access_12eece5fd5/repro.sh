D=$PWD/rtmp; rm -rf $D; mkdir $D
S=$D/sock; mkdir $S
for n in pub sub; do
  initdb -D $D/$n >/dev/null
  echo "listen_addresses=''
unix_socket_directories='$S'
wal_level=logical" >> $D/$n/postgresql.conf
done
echo "port=5501" >> $D/pub/postgresql.conf
echo "port=5502" >> $D/sub/postgresql.conf
pg_ctl -D $D/pub -l $D/pub.log -w start >/dev/null
pg_ctl -D $D/sub -l $D/sub.log -w start >/dev/null
P="psql -X -q -h $S -d postgres"
$P -p 5501 -c "CREATE TABLE t (a int PRIMARY KEY, b int UNIQUE, c int UNIQUE); CREATE PUBLICATION pb FOR TABLE t;"
$P -p 5502 -c "CREATE TABLE t (a int PRIMARY KEY, b int, c int, unique(a,b)) PARTITION BY RANGE (a); CREATE TABLE t_p1 PARTITION OF t FOR VALUES FROM (MINVALUE) TO (100); INSERT INTO t VALUES (55,2,3);"
$P -p 5502 -c "CREATE SUBSCRIPTION sb CONNECTION 'host=$S port=5501 dbname=postgres' PUBLICATION pb WITH (copy_data=false);" >/dev/null
$P -p 5501 -c "INSERT INTO t VALUES (55,2,3);"
i=0
while [ $i -lt 100 ]; do
  grep -q "conflict=multiple_unique_conflicts" $D/sub.log && break
  grep -q "terminated by signal\|TRAP" $D/sub.log && break
  sleep 0.3; i=$((i+1))
done
if grep -q "conflict=multiple_unique_conflicts" $D/sub.log; then echo "conflict reported"; else echo "no conflict reported"; fi
$P -p 5502 -c "SELECT 1" >/dev/null 2>&1 && echo "sub alive" || echo "sub down"
pg_ctl -D $D/pub -m immediate stop >/dev/null; pg_ctl -D $D/sub -m immediate stop >/dev/null
rm -rf $D
