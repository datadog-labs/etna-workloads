D=$PWD/rtmp; rm -rf $D; mkdir -p $D
for n in pub sub; do
  enc=UTF8; [ $n = sub ] && enc=LATIN1
  initdb -D $D/$n -A trust --locale=C --encoding=$enc >/dev/null 2>&1
done
pg_ctl -D $D/pub -o "-c wal_level=logical -c port=54711 -c unix_socket_directories=$D -c listen_addresses=''" -l $D/pub.log -w start >/dev/null
pg_ctl -D $D/sub -o "-c port=54712 -c unix_socket_directories=$D -c listen_addresses='' -c wal_level=logical" -l $D/sub.log -w start >/dev/null
P="psql -X -q -h $D -d postgres -At"
$P -p 54711 -c "create table test1(a int, b text); create publication mypub for all tables;"
$P -p 54712 -c "create table test1(a int, b text);"
$P -p 54712 -c "create subscription mysub connection 'host=$D port=54711 dbname=postgres' publication mypub;" >/dev/null
sleep 2
$P -p 54711 -c "insert into test1 values (1, E'Mot\\xc3\\xb6rhead')"
r=0
for i in $(seq 1 15); do
  r=$($P -p 54712 -c "select count(*) from test1 where b = E'Mot\\xf6rhead'")
  [ "$r" = 1 ] && break; sleep 1
done
echo "replicated rows: $r"
pg_ctl -D $D/sub -m immediate stop >/dev/null
pg_ctl -D $D/pub -m immediate stop >/dev/null
rm -rf $D
