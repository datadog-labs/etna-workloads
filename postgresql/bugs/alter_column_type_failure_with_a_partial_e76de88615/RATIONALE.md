# Rationale

## src/backend/commands/tablecmds.c, RememberIndexForRebuilding()
Traces to the fix_impl.patch hunks in ATExecAlterColumnType that handle indexes directly
dependent on the table. In current code that logic lives in RememberIndexForRebuilding.
The fix defers the decision and drops indexes owned by a constraint that is being rebuilt.
In current code this is the `get_index_constraint()` check that calls
RememberConstraintForRebuilding() instead of queueing the index. I removed that check, so
an index belonging to a partial exclusion constraint, which depends directly on the table
columns, is queued for rebuild as a plain index. The constraint is also rebuilt, so the
index is recreated twice and ALTER COLUMN TYPE fails.

I did not revert the pg_depend.c get_constraint_index `break`->`continue` change (comment-level paranoia path).

## Failing oracle cases
- src/test/regress||alter_table
