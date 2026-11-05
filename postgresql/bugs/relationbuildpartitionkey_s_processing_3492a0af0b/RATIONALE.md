# Rationale
- File: src/backend/utils/cache/partcache.c, function RelationBuildPartitionKey.
- Traces to the fix.patch hunk in RelationBuildPartitionKey that adds `partexprs_item = lnext(...)` after the expression-column branch.
- I removed that advance. With it gone, every expression column in the partition key reads the first expression's type, typmod and collation. This is the original bug.

Failing oracle case: src/test/regress||create_table (to be confirmed by the oracle run).
