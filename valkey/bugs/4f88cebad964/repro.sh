#!/bin/bash
S="$VALKEY_SERVER"; C="$VALKEY_CLI"
P=$PORT; R=$((PORT+1))
"$S" --port $P --save "" --appendonly no --dir . --logfile p.log --enable-debug-command yes &
"$S" --port $R --save "" --appendonly no --dir . --logfile r.log --replicaof "127.0.0.1 $P" &
for p in $P $R; do until "$C" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done
until [ "$("$C" -p $R info replication | grep -c master_link_status:up)" = 1 ]; do sleep 0.1; done
p() { "$C" -p $P "$@"; }; r() { "$C" -p $R "$@"; }
p debug set-active-expire 0 >/dev/null
p hsetex myhash ex 100000 fields 1 f1 1 >/dev/null
p hincrbyfloat myhash f1 1.0
p wait 1 5000 >/dev/null
echo primary: $(p hget myhash f1) ttl-set=$([ "$(p httl myhash fields 1 f1)" -gt 0 ] && echo yes || echo no)
echo replica: $(r hget myhash f1) ttl-set=$([ "$(r httl myhash fields 1 f1)" -gt 0 ] && echo yes || echo no)
p shutdown nosave 2>/dev/null; r shutdown nosave 2>/dev/null
wait
