# Rationale

## Changed hunk
- File: src/backend/executor/execPartition.c, function `ExecFindPartition`
- Traces to the fix.patch hunk that adds the "If this partition is the default one, we must check its partition constraint now" block at the end of the descent loop (`ExecPartitionCheck(rri, slot, estate, true)` when `partidx == default_index`).
- The change removes that block. A default partition's constraint is no longer checked while descending, so a concurrent ATTACH PARTITION that changes the default's constraint goes unnoticed. This is true especially for sub-partitioned default partitions, which ExecInsert never checks. Tuples can be inserted into a default partition that no longer accepts them.
- Only this hunk is reverted. The nonleaf_partitions bookkeeping from the fix is left in place, since the current code is structured differently and the check removal alone restores the bug.

## Failing oracle cases
- src/test/isolation||partition-concurrent-attach (confirmed FAIL with the change)
