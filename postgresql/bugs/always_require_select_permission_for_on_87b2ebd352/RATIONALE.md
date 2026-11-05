# Rationale

## src/backend/parser/parse_clause.c, transformOnConflictArbiter()
Traces to the parse_clause.c hunk of fix_impl.patch. The fix, for an arbiter
given by constraint name (ON CONFLICT ON CONSTRAINT), looks up the constrained
columns and marks the target relation as requiring ACL_SELECT, with those columns
in selectedCols. I reverted this to the old plain `get_relation_constraint_oid()`
call. The current code uses RTEPermissionInfo (perminfo) rather than the RTE, but
the logic is the same. Without it, ON CONFLICT DO UPDATE ON CONSTRAINT does not
require SELECT permission, and the RLS SELECT policies and checks are skipped.

The other fix hunks are left alone: get_relation_constraint_attnos() is now
unused but harmless, and the rowsecurity.c hunk is unchanged.

## Failing oracle cases
- src/test/regress||privileges
- src/test/regress||rowsecurity
