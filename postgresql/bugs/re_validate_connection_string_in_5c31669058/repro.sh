D=$PWD/rc; rm -rf $D
S=$D/s; mkdir -p $S
initdb -D $D/data -A trust >/dev/null 2>&1
cat >> $D/data/postgresql.conf <<C
wal_level=logical
listen_addresses=''
unix_socket_directories='$S'
C
pg_ctl -D $D/data -w -l $D/log start >/dev/null 2>&1
export PGHOST=$S PGPORT=5432
unset PGPASSWORD
psql -X -q -d postgres <<Q
CREATE ROLE u PASSWORD 'secret' LOGIN REPLICATION;
GRANT CREATE ON DATABASE postgres TO u;
GRANT PG_CREATE_SUBSCRIPTION TO u;
CREATE PUBLICATION p;
CREATE SUBSCRIPTION s CONNECTION 'host=$S port=5432 user=u dbname=postgres' PUBLICATION p WITH (create_slot=false, copy_data=false);
ALTER SUBSCRIPTION s OWNER TO u;
Q
echo "local all u md5
local all all trust" > $D/data/pg_hba.conf
pg_ctl -D $D/data -w reload >/dev/null
PGPASSWORD=secret psql -X -d postgres -c "SET SESSION AUTHORIZATION u" -c "ALTER SUBSCRIPTION s REFRESH PUBLICATION" 2>&1 | grep -E 'ERROR|DETAIL' | sed "s#$S#S#g"
pg_ctl -D $D/data -m immediate stop >/dev/null
rm -rf $D
