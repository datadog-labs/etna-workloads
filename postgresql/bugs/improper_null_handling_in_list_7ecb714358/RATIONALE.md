# Rationale

## src/backend/executor/execPartition.c, get_partition_for_tuple()  (PARTITION_STRATEGY_LIST case)
Traces to the fix.patch hunk in get_partition_for_tuple() (partition.c then; the logic now lives in execPartition.c).
The fix made a NULL key only acceptable when a null-accepting list partition exists, and never fell into the bsearch for a NULL key.
I restored the old shape: `if (isnull[0] && accepts_nulls) return null_index; else { bsearch }`.
With a NULL key and no null partition, the code now runs partition_list_bsearch on the null Datum (garbage value) instead of yielding "no partition" (default partition or error). That can route the row to a wrong partition or crash.

## Failing oracle cases
- src/test/regress||insert
