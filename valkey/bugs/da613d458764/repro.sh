"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly yes --appendfsync always --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" HSETEX h1 fnx PXAT 99999999999999 FIELDS 1 f v
"$VALKEY_CLI" -p "$PORT" HSETEX h2 fxx PXAT 99999999999999 FIELDS 1 f v
"$VALKEY_CLI" -p "$PORT" HSETEX h3 FNX PXAT 99999999999999 FIELDS 1 f v
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
echo "fnx/fxx in AOF: $(cat appendonlydir/*.incr.aof | tr -d '\r' | grep -ciE '^f[nx]x$')"
