"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config set stream-node-max-entries 2
for j in 1 2 3; do c XADD mystream "$j-0" xitem v >/dev/null; done
c XTRIM mystream MAXLEN '~' 0 LIMIT 1
c XLEN mystream
c XTRIM mystream MAXLEN '~' 0 LIMIT 2
c XLEN mystream
c shutdown nosave
wait
