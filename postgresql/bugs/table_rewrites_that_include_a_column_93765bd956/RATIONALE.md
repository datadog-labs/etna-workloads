Hunk: src/backend/commands/tablecmds.c, ATRewriteTable (fix.patch's only hunk).
Removed the ExecStoreAllNullTuple(newslot) call (and its comment) after newslot creation in the rewrite branch. New-slot columns are then not initialized to NULL, so a column added without a default alongside one that forces a rewrite gets uninitialized or garbage values, because tab->newvals has no expression for it.

Failing oracle case: src/test/regress||alter_table
