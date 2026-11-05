# Rationale

File: src/backend/commands/tablecmds.c, function ATExecAlterColumnType (both hunks of fix.patch reverted).

1. Hunk 1 (top of function): removed the `if (tab->rewrite)` block that calls RelationClearMissing() and CommandCounterIncrement(). Without it, a table-rewriting ALTER COLUMN TYPE leaves stale attmissingval/atthasmissing, so old rows can get wrong "missing" defaults.
2. Hunk 2 (before setting atttypid): removed the `if (attTup->atthasmissing)` block that repacks the missing-value array with the new type's metadata when no rewrite is needed. Without it, the stored array keeps the old element type.

Failing oracle case: src/test/regress||fast_default
