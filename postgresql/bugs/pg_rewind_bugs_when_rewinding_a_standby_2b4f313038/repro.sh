D=$PWD/rt_tmp; rm -rf $D; mkdir -p $D
P1=$((PGPORT+11)); P2=$((PGPORT+12)); P3=$((PGPORT+13))
export PGHOST=$D PGDATABASE=postgres
C="-c listen_addresses= -c unix_socket_directories=$D -c wal_keep_size=100MB -c fsync=off -c hot_standby=on"
q() { p=$1; shift; psql -X -q -At -p $p -c "$*"; }
wait_t() {
  for i in $(seq 200); do
    r=$(q $1 "$2" 2>/dev/null)
    if [ "$r" = t ]; then return; fi
    sleep 0.2
  done
}
initdb -D $D/n1 -A trust --no-sync >/dev/null
echo "wal_level=replica" >> $D/n1/postgresql.conf
echo "max_wal_senders=10" >> $D/n1/postgresql.conf
pg_ctl -D $D/n1 -o "$C -p $P1" -l $D/n1.log -w start >/dev/null
q $P1 "CREATE TABLE foo(t text); CREATE TABLE bar(t text); INSERT INTO bar VALUES ('in both')"
pg_basebackup -D $D/n2 -p $P1 -X stream -R 2>/dev/null
pg_basebackup -D $D/n3 -p $P1 -X stream -R 2>/dev/null
pg_ctl -D $D/n2 -o "$C -p $P2" -l $D/n2.log -w start >/dev/null
pg_ctl -D $D/n3 -o "$C -p $P3" -l $D/n3.log -w start >/dev/null
sleep 2
pg_ctl -D $D/n1 -m fast -w stop >/dev/null
pg_ctl -D $D/n3 -w promote >/dev/null
echo "primary_conninfo='host=$D port=$P3'" >> $D/n1/postgresql.conf
touch $D/n1/standby.signal
pg_ctl -D $D/n1 -o "$C -p $P1" -l $D/n1.log -w start >/dev/null
echo "primary_conninfo='host=$D port=$P3'" >> $D/n2/postgresql.auto.conf
pg_ctl -D $D/n2 -o "$C -p $P2" -l $D/n2.log -w restart >/dev/null
sleep 1
L=$(q $P3 "SELECT pg_current_wal_lsn()")
wait_t $P1 "SELECT pg_last_wal_replay_lsn() >= '$L'"
pg_ctl -D $D/n1 -w promote >/dev/null
q $P1 "INSERT INTO foo VALUES ('keep this')"
q $P3 "INSERT INTO bar VALUES ('rewind this')"
q $P1 "INSERT INTO foo VALUES ('and this')"
q $P1 "INSERT INTO foo VALUES ('and this too')"
wait_t $P2 "SELECT count(*)>1 FROM bar"
pg_ctl -D $D/n2 -m fast -w stop >/dev/null
pg_ctl -D $D/n3 -m fast -w stop >/dev/null
cp $D/n2/postgresql.conf $D/conf.tmp
pg_rewind --source-server="host=$D port=$P1 dbname=postgres" --target-pgdata=$D/n2 >/dev/null 2>&1
echo "rewind exit: $?"
cp $D/conf.tmp $D/n2/postgresql.conf
pg_ctl -D $D/n2 -o "$C -p $P2" -l $D/n2.log -w start >/dev/null
echo foo; q $P2 "SELECT * FROM foo ORDER BY 1"
echo bar; q $P2 "SELECT * FROM bar ORDER BY 1"
pg_ctl -D $D/n2 -m fast -w stop >/dev/null
pg_ctl -D $D/n1 -m fast -w stop >/dev/null
rm -rf $D
