#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c sadd one 100 101 102 103
c sadd two 100 200 201 202
c zadd three 1 500 1 501 1 502 1 503 1 100
c zinterstore to_here 3 one two three WEIGHTS 0 0 1
c zrange to_here 0 -1
c shutdown nosave
wait
