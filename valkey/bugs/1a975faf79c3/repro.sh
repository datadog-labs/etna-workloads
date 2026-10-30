#!/bin/bash
S="$VALKEY_SERVER"; C="$VALKEY_CLI"
R=$((PORT+1))
mkdir -p p r
echo "user default on nopass ~* &* +@all" > r/user.acl
"$S" --port "$PORT" --save "" --appendonly no --dir p --logfile p.log &
"$S" --port "$R" --save "" --appendonly no --dir r --aclfile user.acl --logfile r.log &
for i in $(seq 100); do
  "$C" -p "$PORT" ping >/dev/null 2>&1 && "$C" -p "$R" ping >/dev/null 2>&1 && break; sleep 0.1
done
"$C" -p "$R" replicaof 127.0.0.1 "$PORT"
for i in $(seq 100); do
  "$C" -p "$R" info replication | grep -q master_link_status:up && break; sleep 0.1
done
"$C" -p "$R" acl setuser joe on nopass '~*' +@all
"$C" -p "$R" acl save
"$C" -p "$R" acl load
"$C" -p "$R" auth joe anything
"$C" -p "$R" ping
"$C" -p "$PORT" shutdown nosave 2>/dev/null
"$C" -p "$R" shutdown nosave 2>/dev/null
wait
