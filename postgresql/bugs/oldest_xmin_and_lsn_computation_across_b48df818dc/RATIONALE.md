# Rationale

## Hunk 1: src/backend/replication/slotfuncs.c, `pg_replication_slot_advance()`
Traces to the sole hunk of fix.patch / fix_impl.patch. It removes the
`ReplicationSlotsComputeRequiredXmin(false); ReplicationSlotsComputeRequiredLSN();`
calls (and comment) before `ReplicationSlotRelease()`. After advancing a slot, the
cluster-wide minimum restart LSN / xmin is no longer recomputed, so WAL older than
the advanced slot is still retained.

## Hunk 2: src/backend/replication/slot.c, `CheckPointReplicationSlots()`
Needed only because the code has evolved. A later change makes the checkpoint
recompute the required LSN when a slot's restart_lsn was saved
(`last_saved_restart_lsn_updated`). That recompute masks hunk 1: the shutdown
checkpoint fixes up the minimum LSN, so the old segment is recycled anyway. I
disabled that recompute so the original failure is observable again. With only
hunk 1, all 63 oracle cases pass.

## Failing oracle case
- src/test/recovery|t/001_stream_rep.pl|WAL segment <N> recycled after physical slot advancing
