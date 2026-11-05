# Rationale

## src/backend/parser/analyze.c, transformOnConflictClause()
Traces to the fix.patch hunk adding `pstate->p_is_insert = false;` in the
`ONCONFLICT_UPDATE` branch of transformOnConflictClause. In current code that
assignment is still there (with a different comment); I removed it.
Without it, p_is_insert stays true while the DO UPDATE SET list is transformed.
transformAssignedExpr() then takes the INSERT path for targets with
indirection (`set f1[1] = ...`). It substitutes a NULL constant for the old
column value instead of the existing row's value, so array and subfield
assignments in ON CONFLICT DO UPDATE give wrong results.

The other fix hunks (removing p_is_update, and `p_is_update = true` becoming
`p_is_insert = false` in transformUpdateStmt) are already in the current code
and are not needed to bring the bug back.

## Failing oracle cases
src/test/regress||arrays
