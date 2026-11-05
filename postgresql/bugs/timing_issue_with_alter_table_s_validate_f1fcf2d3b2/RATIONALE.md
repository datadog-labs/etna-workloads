# Rationale

Changed hunk: `src/backend/commands/tablecmds.c`, `QueueFKConstraintValidation()`.

Traces to the fix.patch hunk in `ATExecValidateConstraint()` that replaced the immediate
`validateForeignKeyConstraint()` call with a `NewConstraint` queued on the work queue for phase 3.
The code has since moved into `QueueFKConstraintValidation`. I reverted it to validate the FK
immediately, with the SPI query run during phase 2. If another subcommand in the same ALTER TABLE
has already queued a table rewrite, the check runs before the rewrite and the index rebuild. It can
then hit an index that has not been rebuilt, or see the old heap. That is the original bug, which
showed up as "could not read block 0 in file ...".

Only the FK path was reverted. The CHECK and NOT NULL paths are unchanged.

Failing oracle case: src/test/regress||alter_table
