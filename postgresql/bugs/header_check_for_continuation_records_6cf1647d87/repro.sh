set -u
D=$PWD/rt; rm -rf $D; mkdir -p $D/arch $D/s
export PGHOST=$D/s PGDATABASE=postgres
P=$D/p
q() { psql -X -At -p $1 -c "$2"; }
initdb -D $P >/dev/null
cat >> $P/postgresql.conf <<C
port=5601
unix_socket_directories='$D/s'
listen_addresses=''
wal_level=replica
archive_mode=on
archive_command='cp %p $D/arch/%f'
max_wal_senders=5
autovacuum=off
checkpoint_timeout=30min
wal_keep_size=1GB
C
echo "local replication all trust" >> $P/pg_hba.conf
pg_ctl -D $P -w -l $D/p.log start >/dev/null
pg_basebackup -p 5601 -D $D/bk -X fetch
q 5601 "CREATE TABLE t AS SELECT 0" >/dev/null
# advance to a spot near the end of a page
while :; do
  off=$(q 5601 "select (pg_logical_emit_message(true,'a','x')-'0/0')::bigint % 8192")
  [ "$off" -gt 7900 ] && [ "$off" -lt 8000 ] && break
done
end=$(q 5601 "select pg_logical_emit_message(true,'a',repeat('0',$((8192-off+100))))")
sp=$(q 5601 "select ((('$end'::pg_lsn-'0/0')::bigint/8192)*8192)")
f=$(q 5601 "select pg_walfile_name('$end')")
pg_ctl -D $P -m immediate stop >/dev/null
dd if=/dev/zero of=$P/pg_wal/$f bs=1 count=8192 seek=$((sp % 16777216)) conv=notrunc 2>/dev/null
cp $P/pg_wal/$f $D/arch/
mk() {
  cp -r $D/bk $D/$1
  cat >> $D/$1/postgresql.conf <<C
port=$2
unix_socket_directories='$D/s'
listen_addresses=''
restore_command='cp $D/arch/%f %p'
C
  touch $D/$1/standby.signal
  chmod 700 $D/$1
  pg_ctl -D $D/$1 -w -l $D/$1.log start >/dev/null
}
mk s1 5602; mk s2 5603
for i in $(seq 100); do grep -q "invalid magic number 0000" $D/s2.log && break; sleep 0.2; done
pg_ctl -D $D/s1 -w promote >/dev/null
q 5602 "select pg_switch_wal()" >/dev/null
q 5602 "INSERT INTO t SELECT * FROM generate_series(1,1000)" >/dev/null
echo "primary_conninfo='port=5602 host=$D/s'" >> $D/s2/postgresql.conf
pg_ctl -D $D/s2 reload >/dev/null
r=none
for i in $(seq 100); do
  r=$(q 5603 "select count(*) from t" 2>/dev/null)
  [ "$r" = 1001 ] && break; sleep 0.2
done
echo "standby2 count: $r"
pg_ctl -D $D/s1 -m immediate stop >/dev/null; pg_ctl -D $D/s2 -m immediate stop >/dev/null
