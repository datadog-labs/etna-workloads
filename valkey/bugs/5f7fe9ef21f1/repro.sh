#!/bin/bash
# Handshake timeout on one side leaves an inconsistent cluster view; fixed
# builds send a MEET when there is an outbound but no inbound link.
cli() { local p=$1; shift; "$VALKEY_CLI" -p "$p" "$@"; }
A=$PORT; B=$((PORT+1)); C=$((PORT+2))
for p in $A $B $C; do
  mkdir -p n$p
  "$VALKEY_SERVER" --port $p --save "" --appendonly no --dir n$p --logfile s.log \
    --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 4000 \
    --enable-debug-command yes &
done
for p in $A $B $C; do
  until [ "$(cli $p ping 2>/dev/null)" = PONG ]; do sleep 0.1; done
done
nnodes() { cli $1 cluster nodes | grep -c connected; }
waitfor() { # port count seconds
  for _ in $(seq $(( $3 * 5 ))); do
    [ "$(nnodes $1)" -ge "$2" ] && return 0; sleep 0.2
  done; return 1
}
cli $B cluster meet 127.0.0.1 $C >/dev/null
waitfor $B 2 10; waitfor $C 2 10
# B drops PONGs, C drops MEETs
cli $B debug drop-cluster-packet-filter 1 >/dev/null
cli $C debug drop-cluster-packet-filter 2 >/dev/null
cli $A cluster meet 127.0.0.1 $B >/dev/null
# wait for B's handshake with A to time out
sleep 8
cli $B debug drop-cluster-packet-filter -1 >/dev/null
cli $C debug drop-cluster-packet-filter -1 >/dev/null
if waitfor $A 3 15 && waitfor $B 3 1 && waitfor $C 3 1; then
  echo "all nodes know each other"
else
  echo "views inconsistent"
fi
for p in $A $B $C; do cli $p shutdown nosave >/dev/null 2>&1; done
wait
