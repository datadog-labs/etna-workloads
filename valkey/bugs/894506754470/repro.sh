S="$VALKEY_SERVER"; C="$VALKEY_CLI"
for i in 0 1 2 3; do
  mkdir -p n$i
  "$S" --port $((PORT+i)) --save "" --appendonly no --dir n$i --logfile s$i.log \
    --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 3000 &
done
for i in 0 1 2 3; do
  until "$C" -p $((PORT+i)) ping >/dev/null 2>&1; do sleep 0.1; done
done
c() { p=$1; shift; "$C" -p $((PORT+p)) "$@"; }
c 0 cluster addslotsrange 1 16383 >/dev/null
c 1 cluster addslots 0 >/dev/null
for i in 1 2 3; do c 0 cluster meet 127.0.0.1 $((PORT+i)) >/dev/null; done
w() { for _ in $(seq 100); do [ "$("$@")" = "$EXP" ] && return; sleep 0.1; done; }
EXP=ok w sh -c "'$C' -p $PORT cluster info | grep -q cluster_state:ok && echo ok"
id0=$(c 0 cluster myid); id1=$(c 1 cluster myid)
c 2 cluster replicate $id0 >/dev/null
c 3 cluster replicate $id1 >/dev/null
EXP=up w sh -c "'$C' -p $((PORT+2)) info replication | tr -d '\r' | grep master_link_status | cut -d: -f2"
c 0 set FOO TEST >/dev/null
slot=$(c 0 cluster keyslot FOO)
EXP=1 w "$C" -p $((PORT+2)) cluster countkeysinslot $slot
echo "replica keys before: $(c 2 cluster countkeysinslot $slot)"
c 1 cluster bumpepoch >/dev/null
c 1 cluster setslot $slot node $id1
EXP=0 w "$C" -p $PORT cluster countkeysinslot $slot
echo "master keys after: $(c 0 cluster countkeysinslot $slot)"
EXP=0 w "$C" -p $((PORT+2)) cluster countkeysinslot $slot
echo "replica keys after: $(c 2 cluster countkeysinslot $slot)"
for i in 0 1 2 3; do c $i shutdown nosave >/dev/null 2>&1; done
wait
