#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c geoadd k1 -0.15307903289794921875 85 n1 0.3515625 85.00019260486917005437 n2
c georadiusbymember k1 n1 4891.94 m
c del k1
c geoadd k1 45 65 n1 -135 85.05 n2
c georadiusbymember k1 n1 5009431 m
c shutdown nosave
wait
