#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c zadd zinfa inf x inf y -inf z 1 w >/dev/null
c zadd zinfb -inf x 5 y -5 z 7 w >/dev/null
for agg in sum min max; do
  echo "== $agg"
  c zinter 2 zinfa zinfb weights 0 1 aggregate $agg withscores
  c zinter 2 zinfb zinfa weights 1 0 aggregate $agg withscores
done
c shutdown nosave
wait
