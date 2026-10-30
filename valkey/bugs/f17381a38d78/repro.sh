#!/bin/bash
M=$PORT; R=$((PORT+1))
"$VALKEY_SERVER" --port $M --save "" --appendonly no --dir . --logfile m.log &
mkdir -p r; (cd r; "$VALKEY_SERVER" --port $R --save "" --appendonly no --dir . --logfile r.log &)
for p in $M $R; do until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done
c() { "$VALKEY_CLI" -p $M "$@" >/dev/null; }
"$VALKEY_CLI" -p $R replicaof 127.0.0.1 $M >/dev/null
until "$VALKEY_CLI" -p $R info replication | grep -q master_link_status:up; do sleep 0.1; done
c xadd s 1-1 a b
c xgroup create s g '$'
c xreadgroup group g u count 1 streams s '>'
c xadd s 2-1 a b
c xadd s 3-1 a b
c xreadgroup group g u count 1 streams s '>'
c xreadgroup group g u count 1 streams s '>'
"$VALKEY_CLI" -p $M wait 1 5000 >/dev/null
for p in $M $R; do
  "$VALKEY_CLI" -p $p xinfo stream s full | grep -A1 -E '^(entries-read|lag)$' | tr '\n' ' '; echo
done
for p in $M $R; do "$VALKEY_CLI" -p $p shutdown nosave >/dev/null 2>&1; done
wait
