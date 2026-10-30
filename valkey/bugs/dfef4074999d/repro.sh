#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c xgroup create s g '$' MKSTREAM
c xadd s 1-1 f v
c xreadgroup group g c streams s '>' >/dev/null
c xack s g 1-1 invalid-id
c xack s g 1-1
c shutdown nosave
wait
