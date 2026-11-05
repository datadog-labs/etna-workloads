# Rationale

## src/backend/commands/tablecmds.c, MergeAttributes()
Traces to the fix.patch hunk that moves the `if (is_partition) { saved_schema = schema; schema = NIL; }`
block from before the duplicate-name check to after it (the hunk also changes the check to `!is_partition && ...`).

I moved the set-aside block back to before the "Check for duplicate names" loop (current names: `saved_columns`/`columns`).
For a partition, `columns` is then empty when the duplicate check runs, so the check never examines the partition's
column-option list. Duplicate column options such as `PARTITION OF ... (a WITH OPTIONS, a WITH OPTIONS)` are no longer
rejected with "column specified more than once".

The `!is_partition &&` guard is left in place. It is redundant once `columns` is empty, so behavior is unchanged.

The other fix hunks (removing `is_from_parent`) are not reversed. The current code no longer has that field,
and the current end-of-function merge logic already matches the fixed version.

## Failing oracle cases
- src/test/regress||create_table
