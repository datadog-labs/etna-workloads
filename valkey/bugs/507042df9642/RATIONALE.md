# Rationale

Fix: in `clusterProcessPacket`, when a primary `sender` is seen turning into a replica of a
same-shard node that is still a replica in our view, the slots of `sender` are moved to the new
primary (`clusterMoveNodeSlots`) together with the role change.

9.0.7 `src/cluster_legacy.c` (branch `nodeIsReplica(sender_claimed_primary)`) changes:
- Removed the `clusterMoveNodeSlots(sender, sender_claimed_primary, ...)` call (reverses the fix's
  `clusterMoveNodeSlots` call hunk; the function itself was since extended for importing/migrating
  slots and is left in place, now unused here). `slots` stays 0, so the "lost N slot(s)" log is skipped.
- Removed the `serverAssert(sender->numslots == 0)` in that branch (reverses the fix's added assert,
  which would otherwise crash instead of reproducing the stale-slot state).

Result: the old primary is flagged replica while still owning slots in the observer's view.

Failing oracle case: "The role change and the slot ownership change should be an atomic operation"
— `Expected '' to be equal to '0-5461'` (R0 still owns slots from R1's view / R3 doesn't).
