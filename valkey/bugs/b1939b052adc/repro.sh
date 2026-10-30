#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@" 2>&1; }
c hmset myhash a 1
c hrandfield myhash -9223372036854775808
c hrandfield myhash -9223372036854775808 withvalues
c sadd myset a
c srandmember myset -9223372036854775808
c zadd myzset 1 a
c zrandmember myzset -9223372036854775808
c zrandmember myzset -9223372036854775808 withscores
c ping
c shutdown nosave
wait
grep -q "ASSERTION FAILED" s.log && echo ASSERTION
exit 0
