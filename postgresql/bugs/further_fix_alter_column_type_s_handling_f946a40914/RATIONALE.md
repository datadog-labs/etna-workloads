# Rationale

File: src/backend/commands/tablecmds.c, function RememberIndexForRebuilding (called from ATExecAlterColumnType).

Traces to the fix_impl.patch hunks that add RememberIndexForRebuilding and replace the
post-scan "drop constraint indexes from changedIndexOids" loop. The fix checks
get_index_constraint() when an index is found as a direct dependent of the column, and
rebuilds the owning constraint instead of the bare index. I removed that check, so an index
that backs a constraint (e.g. a partial exclusion constraint with a direct column dependency)
is rebuilt as a plain index. The constraint is lost or duplicated, which is the pre-fix behavior.

Failing oracle case: src/test/regress||alter_table
