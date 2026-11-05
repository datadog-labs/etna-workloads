# Rationale
File: src/backend/partitioning/partprune.c, function match_boolean_partition_clause (traces to fix.patch hunks in the same function; the noteq/notclause plumbing in match_clause_to_partition_key is left in place but never set).

1. BooleanTest branch: IS NOT TRUE is again treated as "= false" and IS NOT FALSE as "= true" (no *notclause set), ignoring NULL partitions. Pruning wrongly drops the NULL/default partition.
2. Non-BooleanTest branch: for `NOT x` where negate_clause(leftop) equals partkey, the constant is hard-coded false instead of is_not_clause (original bug).

Failing oracle case: src/test/regress||partition_prune
