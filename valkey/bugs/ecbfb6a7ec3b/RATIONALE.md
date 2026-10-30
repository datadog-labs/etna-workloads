# Rationale

Fix (#944) pulled the chain-reduction ("I'm a sub-replica!") block into the
"Primary node changed for this replica?" branch of clusterProcessPacket, *before*
`updateShardId(sender, ...)`, and fixed the log to print the claimed primary's shard.

Changes in `src/cluster_legacy.c` (clusterProcessPacket):
1. Moved the sub-replica chain-reduction block (with its comment) to *after*
   `updateShardId(sender, sender_claimed_primary->shard_id)`. This reverses the
   hunk that added the block before updateShardId. (In 9.0.7 the old out-of-branch
   copy is already gone, so the pre-fix ordering is expressed as "after"; the effect
   is the same: updateShardId rewrites myself->shard_id when sender is myself's
   primary, so `areInSameShard(newprimary, myself)` wrongly returns true and
   clusterSetPrimary is told no full sync is needed -> psync with wrong history.)
2. The "is now a replica of node ... in shard" log prints `sender->shard_id` again
   (reverses the log hunk).

Oracle: "Sub-replica reports zero repl offset and rank, and fails to win election"
- shutdown and sigstop both fail ("Failover does not happened": node 7, the
  sub-replica, wins the election with its stale data instead of node 4). The other 7 cases pass.
