D=$PWD/rp_data
rm -rf $D
initdb -D $D >/dev/null 2>&1
cat >> $D/postgresql.conf <<C
wal_level = minimal
max_wal_senders = 0
autovacuum = off
checkpoint_timeout = 30min
unix_socket_directories = '$D'
listen_addresses = ''
port = 54399
C
pg_ctl -D $D -l $D/log -w start >/dev/null
P="psql -X -A -t -h $D -p 54399 postgres"
$P -c "create table t as select 42" >/dev/null
off() { $P -c "select (pg_current_wal_insert_lsn() - '0/0') % 8192"; }
n=0
while :; do
  o=$(off)
  if [ "$o" -eq 8176 ] || [ "$o" -eq 8184 ]; then break; fi
  gap=$((8176 - o))
  if [ $gap -lt 0 ]; then s=$((8192 - o + 8000)); elif [ $gap -gt 200 ]; then s=$((gap - 100)); else s=0; fi
  $P -c "select pg_logical_emit_message(true,'',repeat('a',$s))" >/dev/null
  n=$((n+1)); [ $n -gt 500 ] && break
done
POS=$($P -c "select pg_current_wal_insert_lsn() - '0/0'")
FILE=$($P -c "select pg_walfile_name(pg_current_wal_insert_lsn())")
pg_ctl -D $D -m immediate -w stop >/dev/null
python3 - $D/pg_wal/$FILE $POS <<'PY'
import sys,struct
f,pos=sys.argv[1],int(sys.argv[2])
fh=open(f,'r+b'); fh.seek(pos%(16*1024*1024)); fh.write(struct.pack('<I',2*1024*1024*1024)); fh.close()
PY
pg_ctl -D $D -l $D/log2 -w start >/dev/null 2>&1
echo "start exit: $?"
grep -c "invalid magic number" $D/log2
pg_ctl -D $D -m immediate stop >/dev/null 2>&1
rm -rf $D
