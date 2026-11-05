# Rationale
- File: src/backend/utils/adt/ruleutils.c, function get_insert_query_def (ON CONFLICT branch).
- Traces to the single fix.patch hunk: `else` -> `else if (confl->constraint != InvalidOid)`.
- Reverted to a bare `else` (removed the `OidIsValid(confl->constraint)` check), so a rule with plain ON CONFLICT (no arbiter, no constraint) calls get_constraint_name(InvalidOid) and errors "cache lookup failed for constraint 0" during deparse.

Failing oracle case: src/test/regress||rules
