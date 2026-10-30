"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@" 2>&1; }
c config set import-mode yes
c set foo bar
c expireat foo -1
c dbsize
c config set import-mode no
sleep 1
c dbsize
c ping
grep -q "ASSERTION FAILED" s.log && echo ASSERTION
c shutdown nosave >/dev/null 2>&1
wait
