# Rationale
File: src/backend/executor/execPartition.c, function ExecFindPartition.
Traces to the fix.patch hunk that moved the `partdesc->nparts == 0` quick exit to after FormPartitionKeyDatum().
Current code errors out for nparts == 0 in the same condition as the no-partition-found case, using values/isnull. I made FormPartitionKeyDatum() be skipped when nparts == 0, so the error path (ExecBuildSlotPartitionKeyDescription) reads uninitialized values/isnull again.

Oracle case expected to fail: src/test/regress||insert
