# Rationale

All changes are in `src/backend/commands/tablecmds.c`, function `ATPostAlterTypeParse`. They correspond to the `ATPostAlterTypeParse` hunks of fix_impl.patch.

1. In the `IsA(stm, IndexStmt)` branch, removed `stmt->idxcomment = GetComment(oldId, RelationRelationId, 0);`. This is the "keep the index's comment" hunk. Without it, a plain index rebuilt by ALTER COLUMN TYPE loses its comment.
2. In the `AT_AddIndex` branch (constraint-backed index), removed `indstmt->idxcomment = GetComment(indoid, ...)`. This is the "keep any comment on the index" hunk. The index behind a PK or unique constraint loses its comment.
3. In the same branch, removed the `RebuildConstraintComment(... AT_PASS_OLD_INDEX ...)` call. This is the "recreate any comment on the constraint" hunk. PK and unique constraints lose their comments.

The `AT_AddConstraint` path still rebuilds comments, so FK and CHECK constraints keep theirs. The fix commit covered only the index and index-constraint cases, which is why this matches the original bug.

Failing oracle case: src/test/regress||alter_table
