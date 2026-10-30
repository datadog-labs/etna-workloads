#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c set foo 1
c setrange foo 2 2
c incrbyfloat foo 1
c get foo | od -c | head -2
c shutdown nosave
wait
