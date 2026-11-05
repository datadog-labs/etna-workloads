D=$PWD/rtmp; rm -rf $D; mkdir -p $D
S=$D/sock; mkdir $S
for n in pub sub; do
  initdb -D $D/$n >/dev/null 2>&1
done
pg_ctl -D $D/pub -o "-c wal_level=logical -c port=54411 -c unix_socket_directories=$S -c listen_addresses=''" -w -l $D/pub.log start >/dev/null
pg_ctl -D $D/sub -o "-c port=54412 -c unix_socket_directories=$S -c listen_addresses=''" -w -l $D/sub.log start >/dev/null
P="psql -X -q -h $S -d postgres"
$P -p 54411 -c "create publication mypub for all tables"
$P -p 54412 -c "create subscription mysub connection 'host=$S port=54411 dbname=postgres' publication mypub"
sleep 3
timeout 15 $P -p 54412 -c "begin; alter subscription mysub disable; alter subscription mysub set (slot_name = none); drop subscription mysub; commit;"
echo "exit: $?"
pkill -f "$D/sub" ; pg_ctl -D $D/sub -m immediate stop >/dev/null 2>&1
pg_ctl -D $D/pub -m immediate stop >/dev/null 2>&1
rm -rf $D
