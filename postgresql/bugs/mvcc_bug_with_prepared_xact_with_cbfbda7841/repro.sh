D=$PWD/rt_$$
mkdir -p $D
SK=$D/sock; mkdir $SK
initdb -D $D/p >/dev/null 2>&1
cat >> $D/p/postgresql.conf <<C
max_prepared_transactions = 5
listen_addresses = ''
unix_socket_directories = '$SK'
port = 54399
hot_standby = on
C
echo "host replication all samehost trust" >> $D/p/pg_hba.conf
pg_ctl -D $D/p -w -l $D/p.log start >/dev/null
P="psql -X -q -At -h $SK -p 54399 postgres"
$P <<S
create table t(a int);
begin;
insert into t values (1);
savepoint s;
insert into t values (2);
prepare transaction 'x';
S
pg_ctl -D $D/p -w stop >/dev/null
cp -r $D/p $D/s
rm -f $D/s/postmaster.pid
touch $D/s/standby.signal
echo "primary_conninfo = 'host=$SK port=54399'" >> $D/s/postgresql.conf
sed -i "s/^port = .*/port = 54398/" $D/s/postgresql.conf
pg_ctl -D $D/p -w -l $D/p.log start >/dev/null
pg_ctl -D $D/s -w -l $D/s.log start >/dev/null
S="psql -X -q -At -h $SK -p 54398 postgres"
for i in $(seq 50); do $S -c "select 1" >/dev/null 2>&1 && break; sleep 0.2; done
echo "standby before commit:"; $S -c "select count(*) from t"
$P -c "commit prepared 'x'"
$P -c "select pg_current_wal_lsn() \gset" >/dev/null 2>&1
sleep 2
echo "standby after commit:"; $S -c "select count(*) from t"
pg_ctl -D $D/s -m immediate stop >/dev/null
pg_ctl -D $D/p -m immediate stop >/dev/null
rm -rf $D
