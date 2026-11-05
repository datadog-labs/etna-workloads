set -e
D=$PWD/rtmp; rm -rf $D; mkdir $D; cd $D
O="openssl req -x509 -newkey rsa:2048 -nodes -days 30 -utf8"
$O -subj "/CN=ServerCA" -keyout ca.key -out ca.crt 2>/dev/null
$O -subj "/CN=OtherCA" -keyout oca.key -out oca.crt 2>/dev/null
openssl req -new -newkey rsa:2048 -nodes -utf8 -subj "/CN=localhost" -keyout srv.key -out srv.csr 2>/dev/null
openssl x509 -req -in srv.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out srv.crt -days 30 2>/dev/null
openssl req -new -newkey rsa:2048 -nodes -utf8 -subj "/CN=Üñïcode" -keyout cli.key -out cli.csr 2>/dev/null
openssl x509 -req -in cli.csr -CA oca.crt -CAkey oca.key -CAcreateserial -out cli.crt -days 30 2>/dev/null
chmod 600 *.key
initdb -D data >/dev/null 2>&1
cat >> data/postgresql.conf <<EOC
ssl=on
ssl_cert_file='$D/srv.crt'
ssl_key_file='$D/srv.key'
ssl_ca_file='$D/ca.crt'
unix_socket_directories='$D'
listen_addresses='127.0.0.1'
port=54329
EOC
echo "hostssl all all 0.0.0.0/0 cert" > data/pg_hba.conf
echo "local all all trust" >> data/pg_hba.conf
pg_ctl -D data -l log -w start >/dev/null
psql -X "sslmode=require sslcert=$D/cli.crt sslkey=$D/cli.key host=localhost hostaddr=127.0.0.1 port=54329 dbname=postgres" -c "select 1" >/dev/null 2>&1 || true
pg_ctl -D data -m fast stop >/dev/null
grep -a "Failed certificate data" log | sed 's/.*subject/subject/; s/, serial number.*//' | cat -v
cd ..; rm -rf $D
