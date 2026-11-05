D=$PWD/_sub; rm -rf $D; mkdir -p $D
PP=54399
initdb -D $D/data -A trust >/dev/null 2>&1
echo "wal_level=logical" >> $PGDATA/postgresql.conf
pg_ctl -D $PGDATA -w -l $D/pub.log restart >/dev/null
SUBPORT=54398
echo "port=$SUBPORT
unix_socket_directories='$D'
listen_addresses=''" >> $D/data/postgresql.conf
pg_ctl -D $D/data -w -l $D/sub.log start >/dev/null
P="psql -X -q -At"
$P -c "create table tab_mixed (a int primary key, b text, c numeric); insert into tab_mixed values (1,'foo',1.1); create publication pub for table tab_mixed"
S="$P -h $D -p $SUBPORT -d postgres"
$S -c "create table tab_mixed (d text default 'local', c numeric, b text, a int primary key)"
$S -c "create subscription sub connection 'host=$PGHOST port=$PGPORT dbname=postgres' publication pub"
sleep 3
$P -c "insert into tab_mixed values (2,'bar',2.2); update tab_mixed set b='baz', c=c+1 where a=1; update tab_mixed set b='quux' where a=2"
sleep 4
$S -c "select * from tab_mixed order by a"
$S -c "drop subscription sub" >/dev/null 2>&1
pg_ctl -D $D/data -m immediate stop >/dev/null
