# Rationale

Fix: a replica that receives `CLUSTER SETSLOT ... NODE` (from the primary link) before gossip never evaluates `cluster-allow-replica-migration`, because only `myself` (not its primary) was considered.

## Change (src/cluster_legacy.c, `clusterCommandSetSlot`, NODE branch)
Reverses the fix's hunk replacing `slot_was_mine = slots[slot] == myself` / `myself->numslots == 0`
with `my_primary`-based checks. In 9.0.7 that logic is `slot_was_mine` and `shard_is_empty`;
they now use `myself` again:
- `slot_was_mine = server.cluster->slots[slot] == myself`
- `shard_is_empty = myself->numslots == 0`

A replica never owns slots, so `slot_was_mine` is false and it never turns into a replica of the new
primary from the SETSLOT path (the pre-fix behaviour). The other fix hunks (assert, protectClient, dont_cache_primary,
discard cached primary) are left alone: they only matter once the replica enters that path.

## Oracle failures
- `...last CLUSTER SETSLOT - gossip` and `- setslot`: server 7 doesn't become a replica of primary 0 in time ("Server 3 and 7 role response has not changed"). 
- `Migrated replica reports zero repl offset and rank ... - sigstop`: replica did not migrate via SETSLOT as expected (sub-replica log assertion fails).
