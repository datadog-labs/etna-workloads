"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
C() { "$VALKEY_CLI" -p "$PORT" "$@"; }
C rpush tmp a b c >/dev/null
( C blpop k 2 > out.txt ) &
sleep 0.5
C rename tmp k
wait %2
cat out.txt
C shutdown nosave 2>/dev/null
wait
