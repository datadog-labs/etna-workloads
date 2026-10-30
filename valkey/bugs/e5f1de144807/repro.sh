"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly yes --dir . --logfile s.log --enable-debug-command yes --stream-node-max-entries 100 &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
for j in $(seq 1 100); do c XADD mystream '*' xitem v >/dev/null; done
c XADD mystream MAXLEN '~' 100 '*' xitem v >/dev/null
c xlen mystream
c config set stream-node-max-entries 1
c debug loadaof
c xlen mystream
c shutdown nosave
wait
