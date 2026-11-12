# Rationale
File: src/src/execution/operator/join/physical_hash_join.cpp, `BuildSideHasMultipleSources` (two hunks, both from the fix's single hunk in that function):
1. Removed the `CTE_SCAN / RECURSIVE_CTE_SCAN / RECURSIVE_RECURRING_CTE_SCAN` case returning true. CTE producers are not children of their scans, so a build side reading a CTE is no longer seen as multi-source, and dict-surviving stays enabled.
2. Removed the early `return false` for single-input sinks. Without it the recursion goes through blocking sinks, so the function walks the whole subtree again.
The comment and the delim-join case are left as they are, because they belong to later changes.

## Oracle
`./bin/etna-check`:
```
FAIL     test/sql/join/hash_join/hash_join_dict_surviving_cte.test
         ...hash_join_dict_surviving_cte.test:38 Query unexpectedly failed
         INTERNAL Error: dict-surviving join: narrowed column 0 received a chunk with an unexpected dictionary; build pipeline is not single-source
1 of 1 oracle units fail
```
