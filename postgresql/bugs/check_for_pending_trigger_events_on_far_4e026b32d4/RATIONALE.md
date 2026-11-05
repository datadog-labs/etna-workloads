# Rationale
File: src/backend/commands/tablecmds.c, function ATExecDropConstraint (the constraint-dropping code).
Traces to the single hunk of fix_impl.patch. I removed the block that, for a foreign-key constraint
on a different table (non-self-referential), opens the referenced table with AccessExclusiveLock and
calls CheckAlterTableIsSafe (formerly CheckTableNotInUse). Without it, dropping an FK constraint
doesn't check the far-end table for pending trigger events, so a trigger with unfired events can be
dropped.

Failing oracle case: src/test/regress||foreign_key
