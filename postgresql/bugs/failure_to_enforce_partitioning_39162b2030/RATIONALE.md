# Rationale

**File/function:** `src/backend/executor/execPartition.c`, `ExecFindPartition()`.

**Traces to:** the `InitResultRelInfo` hunk in `fix_impl.patch`. That hunk makes a leaf partition's `ri_PartitionCheck` use the partition root's own constraint, mapped to the leaf's attribute numbers. Today's equivalent is the up-front check of the root table's partition constraint, which I removed:

    if (rootResultRelInfo->ri_RelationDesc->rd_rel->relispartition)
        ExecPartitionCheck(rootResultRelInfo, slot, estate, true);

**Why this brings the bug back:** routing a tuple into a partitioned table that is itself a partition no longer checks that table's implicit partition constraint. The tuple lands in a leaf partition, and the leaf's constraint doesn't include the ancestor's bounds. So a row that violates the intermediate partition's bounds is accepted.

I re-expressed the fix this way because the signature change in `fix_impl.patch` (the `load_partition_check` argument) no longer exists in the current code.

**Failing oracle case:** `src/test/regress||insert`.
