mkdir -p bk_tmp
psql -X -q -c "create role backupuser login replication in role pg_write_server_files" postgres
echo "host replication all samehost trust" >/dev/null
D=$PWD/bk_tmp/out
pg_basebackup -U backupuser --target server:$D -X none -d "host=$PGHOST port=$PGPORT dbname=postgres" >/dev/null 2>&1
echo "exit: $?"
ls $D 2>&1 | sed 's/^ls:.*/missing/'
psql -X -q -At -c "select 'alive'" postgres 2>&1 | head -1
rm -rf bk_tmp
