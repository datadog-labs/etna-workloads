# Rationale
Bug: ALTER COLUMN TYPE on a column with an inherited CHECK constraint (bug #13779) mishandles child tables.

Hunks (all trace to fix.patch):
1. src/backend/utils/adt/ruleutils.c, pg_get_constraintdef_worker: emit `ALTER TABLE ONLY` instead of plain `ALTER TABLE` (ruleutils hunk at ~1363). Re-added parent constraints no longer recurse via the command text.
2. src/backend/commands/tablecmds.c, ATExecCmd AT_ReAddConstraint: recurse=false instead of true (hunk at ~3516).
3. tablecmds.c, ATAddCheckNNConstraint: allow_merge is `recursing` only (was `recursing || is_readd`), and return early when `is_readd` (hunks at ~6125/6174), so re-adds don't recurse or merge with child constraints.
4. tablecmds.c, ATPostAlterTypeCleanup: removed the `if (!conislocal) continue;` skip so inherited-only constraints are re-injected from their own definitions (hunk at ~8584).

Together children's inherited constraints are rebuilt wrongly (duplicate/ non-inherited constraint state).

Failing oracle case: src/test/regress||alter_table (see oracle output).
