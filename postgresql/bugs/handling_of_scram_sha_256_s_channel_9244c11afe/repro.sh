D=$PWD/rsapss_tmp
rm -rf $D; mkdir -p $D; cd $D
openssl genpkey -algorithm rsa-pss -pkeyopt rsa_keygen_bits:2048 -out s.key 2>/dev/null
openssl req -new -x509 -key s.key -subj /CN=localhost -days 30 -out s.crt 2>/dev/null
chmod 600 s.key
initdb -D data -A trust >/dev/null 2>&1
cat >> data/postgresql.conf <<C
ssl=on
ssl_cert_file='$D/s.crt'
ssl_key_file='$D/s.key'
listen_addresses='127.0.0.1'
unix_socket_directories='$D'
port=54399
C
pg_ctl -D data -w -l log start >/dev/null 2>&1
psql -X -h $D -p 54399 -d postgres -qc "create role u login password 'x'" >/dev/null 2>&1
echo "hostssl all u 127.0.0.1/32 scram-sha-256" > data/pg_hba.conf
echo "local all all trust" >> data/pg_hba.conf
pg_ctl -D data -w reload >/dev/null 2>&1
PGPASSWORD=x PGSSLMODE=require PGCHANNELBINDING=require psql -X -h 127.0.0.1 -p 54399 -U u -d postgres -Atc "select 'connected'" 2>&1
pg_ctl -D data -m fast stop >/dev/null 2>&1
cd ..; rm -rf $D
