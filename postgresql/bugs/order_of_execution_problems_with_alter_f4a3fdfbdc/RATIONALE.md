# Re-introduced bug: ALTER TABLE ADD PRIMARY KEY order-of-execution

Current code differs structurally from the fix (not-null handling is now constraint based, with
ATPrepAddPrimaryKey queuing the NOT NULL constraints before the index pass). I re-expressed the reverse:

1. `src/backend/catalog/index.c`, `index_check_primary_key()` — traces to the index.c hunks of fix.patch.
   Instead of erroring on unmarked PK columns, it again collects AT_SetNotNull subcommands and runs its own
   nested `AlterTableInternal()` (inside EventTriggerAlterTableStart/End). That nested ALTER executes in the
   middle of the outer ALTER TABLE, so operations are not performed in the proper overall order.
2. `src/backend/commands/tablecmds.c`, `ATPrepAddPrimaryKey()` — traces to the tablecmds.c/parse_utilcmd.c
   hunks that made the parser/prep stage insert the SET NOT NULL operations up front. The early `return`
   disables that queuing, so the NOT NULL work is left to the nested ALTER in (1) (the old behavior).

## Failing oracle cases
- src/test/modules/test_ddl_deparse||alter_table
- src/test/regress||alter_table
- src/test/regress||indexing
