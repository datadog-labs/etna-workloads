#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --enable-debug-command yes >/dev/null &
SRV=$!
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config set rdb-key-save-delay 10000000 >/dev/null
c debug populate 100 >/dev/null
c config set appendonly yes >/dev/null
c set foo bar >/dev/null
echo "$(c info persistence | tr -d '\r' | grep aof_rewrite_in_progress)"
# kill the AOFRW child so the initial rewrite fails
kill -9 $(pgrep -P $SRV)
sleep 1
echo "manifest files: $(ls appendonlydir 2>/dev/null | grep -c manifest)"
echo "base files: $(ls appendonlydir 2>/dev/null | grep -c base)"
c config set rdb-key-save-delay 0 >/dev/null
sleep 1
kill -9 $(pgrep -P $SRV) 2>/dev/null
c shutdown nosave force >/dev/null 2>&1
wait
