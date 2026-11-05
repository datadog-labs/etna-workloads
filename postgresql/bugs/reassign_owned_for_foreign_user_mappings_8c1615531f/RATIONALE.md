# Rationale
File: src/backend/catalog/pg_shdepend.c, function shdepReassignOwned (the second switch on classId, ~line 1678).
Traces to the fix.patch hunk adding `case UserMappingRelationId: /* ditto */ break;`. I removed that case, so user mappings fall through to the default branch, which raises an unexpected-object error in REASSIGN OWNED. The pg_user_mapping.h include was already needed elsewhere, so I left it.

Failing oracle case: src/test/regress||foreign_data
