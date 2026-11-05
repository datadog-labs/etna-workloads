# Rationale

Hunk: src/backend/commands/tablecmds.c, ATExecCmd(), case AT_ReAddConstraint.
Traces to the fix.patch ATExecCmd/ATAddCheckConstraint hunks that introduced AT_ReAddConstraint and is_readd.
Today's code re-adds with recurse=true, is_readd=true (recursion allowed, merging handled). Pre-fix, re-adds used
recurse=false with no is_readd early return in ATAddCheckNNConstraint; I changed the call to recurse=false. With recurse=false, ATAddCheckNNConstraint
errors "constraint must be added to child tables too" when the table has children, which is the
original bug (ALTER COLUMN TYPE on a column with an inherited check constraint fails).

Failing oracle case: src/test/regress||alter_table
