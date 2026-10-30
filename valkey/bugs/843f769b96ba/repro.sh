#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c zadd z 5 a
c zadd z lt incr 1 a
c zadd z gt incr -1 a
c zscore z a
c zadd z lt incr -1 a
c zadd z gt incr 1 a
c zadd z 0 b
c zadd z gt incr inf b
c zadd z gt incr -inf b
c zadd z lt incr -inf b
c zadd z lt incr inf b
c zscore z b
c shutdown nosave
wait
