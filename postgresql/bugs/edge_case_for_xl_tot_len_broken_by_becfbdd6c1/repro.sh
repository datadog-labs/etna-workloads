D=$PWD/rtmp_cluster
rm -rf $D; mkdir -p $D
S=$D/s
initdb -D $D/data >/dev/null 2>&1
cat >> $D/data/postgresql.conf <<EOC
wal_level = minimal
max_wal_senders = 0
autovacuum = off
checkpoint_timeout = 30min
listen_addresses = ''
unix_socket_directories = '$D'
EOC
pg_ctl -D $D/data -w -l $D/log start >/dev/null 2>&1
P="psql -X -qAt -h $D -d postgres"
$P -c "select pg_switch_wal()" >/dev/null
$P -c "select pg_logical_emit_message(true,'a','x')" >/dev/null
# advance until insert position is 16 bytes before the end of a WAL page
$P <<'EOQ' >/dev/null
DO $$
DECLARE off int; gap int; n int;
BEGIN
  FOR i IN 1..50 LOOP
    off := (pg_current_wal_insert_lsn() - '0/0'::pg_lsn)::bigint % 8192;
    gap := (8184 - off + 8192) % 8192;
    EXIT WHEN gap <= 8;
    IF gap > 4200 THEN n := 4000; ELSIF gap >= 72 THEN n := gap - 70; ELSE n := 0; END IF;
    PERFORM pg_logical_emit_message(false,'a',repeat('x',n), true);
  END LOOP;
END $$;
EOQ
LSN=$($P -c "select pg_current_wal_insert_lsn()")
FILE=$($P -c "select pg_walfile_name('$LSN')")
OFF=$($P -c "select (pg_current_wal_insert_lsn() - pg_walfile_name_offset(pg_current_wal_insert_lsn()).file_name::text::pg_lsn)" 2>/dev/null)
OFF=$($P -c "select file_offset from pg_walfile_name_offset('$LSN')")
pg_ctl -D $D/data -m immediate stop >/dev/null 2>&1
# write xl_tot_len = 1 (little endian) at the end position
printf '\001\000\000\000' | dd of=$D/data/pg_wal/$FILE bs=1 seek=$OFF conv=notrunc 2>/dev/null
pg_ctl -D $D/data -w -l $D/log2 start >/dev/null 2>&1
grep -o "invalid record length.*" $D/log2 | sed "s/[0-9A-F]*\/[0-9A-F]*/LSN/g"
pg_ctl -D $D/data -m immediate stop >/dev/null 2>&1
rm -rf $D
