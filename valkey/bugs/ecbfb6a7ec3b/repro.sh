S="$VALKEY_SERVER"; C="$VALKEY_CLI"
for i in 0 1 2; do
  mkdir -p n$i
  "$S" --port $((PORT+i)) --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 1000 \
    --save "" --appendonly no --dir n$i --logfile s.log --enable-debug-command yes \
    --cluster-allow-replica-migration no --cluster-migration-barrier 999 &
done
for i in 0 1 2; do until "$C" -p $((PORT+i)) ping >/dev/null 2>&1; do sleep 0.1; done; done
c() { p=$1; shift; "$C" -p $((PORT+p)) "$@"; }
c 0 cluster addslotsrange 1 16383 >/dev/null
c 1 cluster addslots 0 >/dev/null
c 1 config set cluster-allow-replica-migration yes
c 0 cluster meet 127.0.0.1 $((PORT+1)) >/dev/null
c 0 cluster meet 127.0.0.1 $((PORT+2)) >/dev/null
until c 0 cluster info | grep -q cluster_state:ok && [ "$(c 2 cluster nodes | wc -l)" = 3 ]; do sleep 0.2; done
c 2 cluster replicate "$(c 1 cluster myid)" >/dev/null
until [ "$(c 2 role | head -1)" = slave ] && c 2 info replication | grep -q master_link_status:up; do sleep 0.2; done
c 1 set k v >/dev/null
c 1 debug set-active-expire 1 >/dev/null
# make primary 0 hang in full sync
c 0 config set rdb-key-save-delay 100000000 >/dev/null
# move slot 0 from node1 to node0
id0=$(c 0 cluster myid); id1=$(c 1 cluster myid)
c 0 cluster setslot 0 importing $id1 >/dev/null
c 1 cluster setslot 0 migrating $id0 >/dev/null
c 1 cluster setslot 0 node $id0 >/dev/null
c 0 cluster setslot 0 node $id0 >/dev/null
for i in 1 2; do
  until [ "$(c $i cluster nodes | grep myself | grep -c "slave $id0")" = 1 ]; do sleep 0.2; done
done
sleep 2
grep -q "I'm a sub-replica" n2/s.log && echo SUBREPLICA
c 2 info replication | grep -E "master_link_status|master_sync_in_progress"
c 2 dbsize
grep -q "Trying a partial resynchronization" n2/s.log && echo TRIED_PSYNC || echo NO_PSYNC
for i in 0 1 2; do c $i shutdown nosave >/dev/null 2>&1; done
wait
