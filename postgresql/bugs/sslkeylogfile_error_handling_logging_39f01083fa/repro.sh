D=$PWD/sslt_tmp
rm -rf $D
mkdir -p $D
openssl req -new -x509 -nodes -days 2 -subj /CN=localhost -newkey rsa:2048 -keyout $D/server.key -out $D/server.crt >/dev/null 2>&1
chmod 600 $D/server.key
initdb -D $D/data >/dev/null 2>&1
cp $D/server.key $D/server.crt $D/data/
cat >> $D/data/postgresql.conf <<EOC
ssl=on
listen_addresses='127.0.0.1'
unix_socket_directories='$D'
port=54399
EOC
pg_ctl -D $D/data -l $D/log -w start >/dev/null 2>&1
PGSSLMODE=require psql -X -h 127.0.0.1 -p 54399 -d "dbname=postgres sslkeylogfile=$D/invalid/key.txt" -Atc "select 1" 2>&1 | sed 's/"[^"]*invalid/"DIR\/invalid/'
pg_ctl -D $D/data -m immediate stop >/dev/null 2>&1
rm -rf $D
