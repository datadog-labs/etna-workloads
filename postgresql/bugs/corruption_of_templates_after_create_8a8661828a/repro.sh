D=$PWD/rc_data; S=$PWD/rc_sock
rm -rf $D $S; mkdir -p $S
initdb -D $D >/dev/null 2>&1
O="-c listen_addresses= -k $S -p 5499"
pg_ctl -D $D -o "$O" -w -l $PWD/rc.log start >/dev/null
P="psql -X -A -t -h $S -p 5499"
$P -d postgres -c "CREATE DATABASE test_db_1 STRATEGY WAL_LOG TEMPLATE template1;"
$P -d template1 -c "CREATE TABLE tab_db_after_create_1 (a INT);"
$P -d postgres -c "CHECKPOINT;"
pg_ctl -D $D -m immediate -w stop >/dev/null
pg_ctl -D $D -o "$O" -w -l $PWD/rc.log start >/dev/null
$P -d template1 -c "SELECT count(*) FROM pg_class WHERE relname LIKE 'tab_db_%';"
pg_ctl -D $D -m fast -w stop >/dev/null
rm -rf $D $S $PWD/rc.log
