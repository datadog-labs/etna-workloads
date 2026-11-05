D=$PWD/sslc; rm -rf $D; mkdir -p $D
initdb -D $D/data >/dev/null 2>&1
openssl req -new -x509 -nodes -days 2 -subj /CN=localhost -keyout $D/data/server.key -out $D/data/server.crt >/dev/null 2>&1
chmod 600 $D/data/server.key
P=$((PGPORT + 1))
pg_ctl -D $D/data -w -l $D/log -o "-c ssl=on -c listen_addresses=127.0.0.1 -c port=$P -c unix_socket_directories=$D" start >/dev/null
PGSSLMODE=require psql -X -h 127.0.0.1 -p $P -d postgres -At -c "SELECT ssl, client_dn IS NULL AS dn_null FROM pg_stat_ssl WHERE ssl"
pg_ctl -D $D/data -m fast stop >/dev/null
rm -rf $D
