# Rationale

All changes are in `src/backend/commands/tablecmds.c`.

1. `RenameRelation()`: reverts the retry loop in the fix.patch hunk that introduced `is_index_stmt`. The lock mode is again picked only from the statement type (ALTER INDEX gives ShareUpdateExclusiveLock, everything else gives AccessExclusiveLock). The relkind of the locked object is never checked. `ALTER INDEX` on a table, or `ALTER TABLE` on an index, therefore takes the wrong lock level. The variable keeps the name `is_index_stmt` because the current code uses it.
2. `RenameRelationInternal()`: removes the `Assert` added by the fix. The assert checked that the caller's `is_index` flag matches the object's relkind.

Failing oracle case: `src/test/regress||alter_table`.
