#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --cluster-enabled yes &
for i in $(seq 50); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.2; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config set cluster-announce-ip "10.0.0.1 injected"
c config set cluster-announce-ip "10.0.0.1,evil"
c config set cluster-announce-ip "10.0.0.1=evil"
c config set cluster-announce-ip $'10.0.0.1\n'
c config set cluster-announce-human-nodename "a b"
c config set cluster-announce-human-nodename "a,b"
c config set cluster-announce-human-nodename "a=b"
c config set cluster-announce-human-nodename 'a"b'
c shutdown nosave
wait
