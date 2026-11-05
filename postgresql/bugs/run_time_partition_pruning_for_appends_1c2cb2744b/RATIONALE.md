# Rationale

## Changed hunk
- File: src/backend/executor/execPartition.c, function `ExecFindMatchingSubPlans`.
- Traces to the fix.patch hunk that tracks subplans not belonging to any
  partitioning hierarchy (`other_subplans`) and makes sure they are never
  pruned ("Add in any subplans that partition pruning didn't account for").
- Removing `result = bms_add_members(result, prunestate->other_subplans);`
  brings the bug back: for an Append built from UNION ALL with children that
  are outside any partition hierarchy, run-time pruning drops those children.

## Failing oracle cases
- src/test/regress||partition_prune (confirmed FAIL with the change)
