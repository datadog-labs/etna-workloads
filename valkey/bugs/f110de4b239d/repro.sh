"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config set hash-max-listpack-value 8
c hset bighash tmp 0
c hincrbyfloat bighash tmp 0.0000005
c object encoding bighash
c hincrbyfloat bighash2 abcdefghi 1
c object encoding bighash2
c shutdown nosave
wait
