# Rationale

Hunk: src/backend/commands/tablecmds.c, ATExecSetNotNull().
Traces to the fix.patch hunk in ATExecSetNotNull that adds the check
"if (conForm->connoinherit && recurse) ereport(ERROR, ... cannot change NO INHERIT status ...)".
That check is removed again, so ALTER TABLE ... ADD CONSTRAINT NOT NULL (recursing)
on a column with an existing NO INHERIT not-null constraint no longer errors.
The constraint is silently accepted instead of being rejected.

The other fix hunks (heap.c, pg_constraint.c AdjustNotNullInheritance1, ATPrepCmd) were
rewritten upstream; the current code has no equivalent, so only this hunk was reverted.

Failing oracle case: src/test/regress||inherit
