D=$PWD/rc_data; S=$PWD/rc_sock
rm -rf $D $S; mkdir -p $S
initdb -D $D >/dev/null 2>&1
pg_ctl -D $D -o "-k $S -c listen_addresses= -c shared_buffers=128kB -c fsync=off -c full_page_writes=off -c autovacuum=off" -w -l $D/log start >/dev/null 2>&1
export PGHOST=$S PGPORT=5432 PGDATABASE=postgres
P="psql -X -A -t -q"
$P -c "CREATE DATABASE tmpl OID=50000"
$P -d tmpl -c "CREATE TABLE large(id serial primary key, a text, b text); INSERT INTO large(a,b) SELECT i::text,1 FROM generate_series(1,4000) i"
$P -c "CREATE DATABASE cdb TEMPLATE tmpl OID=50001"
$P -c "CREATE TABLE rs(d text); INSERT INTO rs SELECT repeat('x',50) FROM generate_series(1,15000)"
mkfifo $D/in
( cat $D/in | $P > $D/aout 2>&1 ) &
exec 3>$D/in
echo "BEGIN;" >&3
$P -d cdb -c "UPDATE large SET b=1"
echo "UPDATE rs SET d=d; UPDATE rs SET d=d;" >&3; sleep 3
$P -c "DROP DATABASE cdb"
$P -c "CREATE DATABASE cdb TEMPLATE tmpl OID=50001"
$P -d cdb -c "UPDATE large SET b=2"
echo "UPDATE rs SET d=d; UPDATE rs SET d=d;" >&3; sleep 3
$P -d cdb -c "SELECT b, count(*) FROM large GROUP BY b"
echo "ROLLBACK;" >&3
exec 3>&-
sleep 1
pg_ctl -D $D -m immediate stop >/dev/null 2>&1
rm -rf $D $S
