#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c function load "#!lua name=test1
server.register_function('f1', function() return 1 end)
server.register_function('f2', function() return 1 end)"
c function load "#!lua name=test1
server.register_function('f3', function() return 1 end)"
c function stats
c ping
c shutdown nosave
wait
