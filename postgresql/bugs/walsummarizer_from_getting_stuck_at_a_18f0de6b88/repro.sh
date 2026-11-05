D=$(mktemp -d "$PWD/t.XXXXXX")
S=$D/s; mkdir $S
P1=$((PGPORT+11)); P2=$((PGPORT+12)); P3=$((PGPORT+13))
q() { psql -X -qAt -h $S -p $1 -d postgres -c "$2"; }
poll() { i=0; while [ $i -lt 90 ]; do r=$(q $1 "$2"); [ "$r" = t ] && return 0; sleep 0.5; i=$((i+1)); done; return 1; }
mkdir $D/arch
initdb -D $D/n1 >/dev/null 2>&1
cat >> $D/n1/postgresql.conf <<EOM
autovacuum = off
listen_addresses = ''
unix_socket_directories = '$S'
port = $P1
EOM
pg_ctl -D $D/n1 -w -l $D/n1.log start >/dev/null
pg_basebackup -h $S -p $P1 -D $D/n2 -R -X stream
cat >> $D/n2/postgresql.conf <<EOM
port = $P2
archive_mode = always
archive_command = 'cp %p $D/arch/%f'
EOM
pg_ctl -D $D/n2 -w -l $D/n2.log start >/dev/null
pg_basebackup -h $S -p $P2 -D $D/n3 -X stream
: > $D/n3/postgresql.auto.conf
touch $D/n3/standby.signal
cat >> $D/n3/postgresql.conf <<EOM
port = $P3
primary_conninfo = ''
restore_command = 'cp $D/arch/%f %p'
wal_retrieve_retry_interval = '500ms'
archive_command = ''
EOM
pg_ctl -D $D/n3 -w -l $D/n3.log start >/dev/null
q $P1 "select pg_switch_wal(); create table dummy ();" >/dev/null
L=$(q $P1 "select pg_current_wal_insert_lsn()")
poll $P2 "select pg_last_wal_replay_lsn() >= '$L'" >/dev/null
pg_ctl -D $D/n2 -w promote >/dev/null
poll $P2 "select not pg_is_in_recovery()" >/dev/null
SW=$(q $P2 "select pg_switch_wal()" | tail -1)
q $P2 "checkpoint" >/dev/null
poll $P3 "select pg_last_wal_replay_lsn() >= '$SW'::pg_lsn" >/dev/null
cat >> $D/n3/postgresql.conf <<EOM
summarize_wal = on
EOM
pg_ctl -D $D/n3 reload >/dev/null
if poll $P3 "select exists (select * from pg_available_wal_summaries() where tli = 2)"; then
  echo "summarizer passed timeline switch"
else
  echo "summarizer stuck at timeline switch"
fi
for n in n3 n2 n1; do pg_ctl -D $D/$n -m immediate stop >/dev/null; done
rm -rf $D
