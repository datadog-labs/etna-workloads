#!/bin/bash
# A = source (slots 8192-16383), B = import target (0-8191), C = replica of B
A=$PORT; B=$((PORT+1)); C=$((PORT+2))
for p in $A $B $C; do
  mkdir -p n$p
  "$VALKEY_SERVER" --port $p --save "" --appendonly no --dir n$p --logfile s.log \
    --cluster-enabled yes --cluster-config-file nodes.conf --cluster-databases 16 \
    --cluster-allow-replica-migration no --enable-debug-command yes &
done
for p in $A $B $C; do
  until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done
done
cli() { local p=$1; shift; "$VALKEY_CLI" -p "$p" "$@"; }
cli $A cluster addslotsrange 8192 16383 >/dev/null
cli $B cluster addslotsrange 0 8191 >/dev/null
cli $A cluster meet 127.0.0.1 $B >/dev/null
cli $A cluster meet 127.0.0.1 $C >/dev/null
until [ "$(cli $A cluster info | grep -c 'cluster_state:ok')" = 1 ] && \
      [ "$(cli $B cluster info | grep -c 'cluster_known_nodes:3')" = 1 ] && \
      [ "$(cli $C cluster info | grep -c 'cluster_known_nodes:3')" = 1 ]; do sleep 0.2; done
cli $C cluster replicate "$(cli $B cluster myid)" >/dev/null
until cli $C info replication | grep -q master_link_status:up; do sleep 0.2; done
BID=$(cli $B cluster myid)
for p in $A $B $C; do cli $p debug slotmigration prevent-pause 1 >/dev/null; done

# target last replicated a write in db 1
cli $B -n 1 set "{06S}:pre" v >/dev/null
# snapshot of keys in db 2 on the source
for i in 1 2 3; do cli $A -n 2 set "{6ZJ}:snap$i" v >/dev/null; done
cli $A cluster migrateslots slotsrange 16383 16383 node "$BID" >/dev/null
until cli $A cluster getslotmigrations | grep -q waiting-to-pause; do sleep 0.1; done
# incremental write in db 2, proxied after the snapshot
cli $A -n 2 set "{6ZJ}:inc1" v >/dev/null
until [ "$(cli $B -n 2 cluster countkeysinslot 16383)" = 4 ]; do sleep 0.1; done
# target's own writes while the proxied stream is in db 2
cli $B -n 1 set "{06S}:a" v >/dev/null
cli $B -n 0 set "{06S}:b" v >/dev/null
# proxied again
cli $A -n 2 set "{6ZJ}:inc2" v >/dev/null
until [ "$(cli $B -n 2 cluster countkeysinslot 16383)" = 5 ]; do sleep 0.1; done
for p in $A $B $C; do cli $p debug slotmigration prevent-pause 0 >/dev/null; done
until cli $B cluster getslotmigrations | grep -q success; do sleep 0.1; done
sleep 1
for db in 0 1 2; do
  echo "db $db: primary=$(cli $B -n $db dbsize) replica=$(cli $C -n $db dbsize)"
done
for p in $A $B $C; do cli $p shutdown nosave >/dev/null 2>&1; done
wait
