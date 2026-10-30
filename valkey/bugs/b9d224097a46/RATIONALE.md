# Rationale

Fix: role changes (replica promoted / primary demoted) must be broadcast to all nodes via
`CLUSTER_TODO_BROADCAST_ALL`. In 9.0.7 the flag and the debug command already exist, and the
broadcast was spread over several call sites. I removed it from the two role-change sites
(src/cluster_legacy.c):

1. `clusterUpdateSlotsConfigWith`, the branch where myself becomes a replica of `sender`
   (fix hunk 1, which added `CLUSTER_TODO_BROADCAST_ALL` there): dropped the flag again.
2. `clusterFailoverReplaceYourPrimary` step 4 (fix hunk 2, which replaced the immediate
   `clusterBroadcastPong` with the flag): dropped the broadcast, so the new primary no longer
   pongs everyone after the failover.

Other nodes learn the role change only at the next regular ping/pong, as before the fix.

## Oracle
"Broadcast PONG to the cluster when the node role changes" fails: with ping interval 300s and
random ping disabled, other nodes still see R0/R3 with old roles ("Node role does not changed
in the first failover"). The other 20 cases pass.
