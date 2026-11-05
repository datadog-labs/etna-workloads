# Rationale

File: src/backend/catalog/index.c, function `index_constraint_create`.

Traces to the single index.c hunk set in fix_impl.patch:
- Variable `idxaddr` renamed back to `referenced`.
- The index→constraint INTERNAL dependency is recorded again with `myself` = index and `referenced` = constraint.
- `myself` is set to the constraint only inside the `parentConstraintId` branch, where `referenced` is reused.
- The function returns `referenced` instead of `myself`.

Effect: the returned ObjectAddress is whatever `referenced` was last set to. For a partitioned PK or unique constraint that is the partition's table (from the PARTITION_SEC dependency), not the constraint. For a non-partition constraint it is the constraint. Callers that use the returned address (for example ALTER TABLE ... ADD CONSTRAINT and event triggers/dependency handling) therefore get the wrong object for partitions.

Oracle case expected to fail: src/test/regress||indexing
