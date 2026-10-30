Reproducer: 3-primary + 1-replica cluster (node3 replicates node0), with random pings disabled,
cluster-ping-interval 300000 and node-timeout 60000, so role changes only propagate via the
PONG broadcast on role change. Run `cluster failover` on node3, wait for node0 to become a
replica, then `cluster failover` on node0 (the pre-fix test's second failover).
Clean: the broadcast tells everyone the roles flipped, the second failover succeeds
(node0 master, node3 slave). Buggy: no PONG broadcast, node3 still sees node0 as primary and
rejects MFSTART, so the manual failover does not happen (node0 slave, node3 master).
