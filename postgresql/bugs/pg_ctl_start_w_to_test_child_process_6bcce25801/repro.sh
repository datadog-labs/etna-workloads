D=$PWD/rtmp_data
rm -rf "$D"
initdb -D "$D" >/dev/null 2>&1
pg_ctl -D "$D" -o "-c listen_addresses='' -c unix_socket_directories=$PWD" -w -l "$D/log" start >/dev/null 2>&1
echo "start exit: $?"
pg_ctl -D "$D" stop -m fast >/dev/null 2>&1
echo "stop exit: $?"
rm -rf "$D"
