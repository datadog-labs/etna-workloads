# Rationale

File: src/backend/partitioning/partprune.c, function match_clause_to_partition_key()

Traces to the fix.patch hunk that added the `if (noteq)` block (here named `notclause`) and changed `op_is_ne = noteq` to `false`. The reverse is applied:
- Removed the block that rewrote "partkey IS NOT true/false" into "IS false/true OR partkey IS NULL".
- Restored `partclause->op_is_ne = notclause;`.

Effect: IS NOT TRUE/FALSE is pruned as a boolean "<>" partclause, which never matches the NULL partition, so that partition is wrongly pruned.

Oracle case expected to fail: src/test/regress||partition_prune
