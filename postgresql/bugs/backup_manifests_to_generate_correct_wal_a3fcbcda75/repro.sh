D=$PWD/x; rm -rf $D; mkdir -p $D
S=$PWD
initdb -D $D/d -A trust -N >/dev/null 2>&1
O="-c unix_socket_directories=$S -c listen_addresses= -c port=54329"
pg_ctl -D $D/d -o "$O" -w -l $D/log start >/dev/null 2>&1
pg_ctl -D $D/d -w stop >/dev/null 2>&1
touch $D/d/standby.signal
pg_ctl -D $D/d -o "$O" -w -l $D/log start >/dev/null 2>&1
pg_ctl -D $D/d -w promote >/dev/null 2>&1
psql -X -q -h $S -p 54329 -d postgres -c "SELECT pg_switch_wal()" >/dev/null
pg_basebackup -h $S -p 54329 -D $D/bk --no-sync && echo basebackup ok
pg_verifybackup $D/bk >/dev/null 2>&1 && echo verify ok || echo verify failed
pg_ctl -D $D/d -m immediate stop >/dev/null 2>&1
rm -rf $D
