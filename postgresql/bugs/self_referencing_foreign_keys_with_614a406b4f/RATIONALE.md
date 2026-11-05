# Rationale

Changed hunk: `src/backend/catalog/pg_constraint.c`, `get_relation_idx_constraint_oid()`.
Traces to the fix.patch hunk adding the contype filter (PRIMARY/UNIQUE/EXCLUSION) in that function. I removed the filter, so a foreign-key constraint whose conindid equals the index is matched. For self-referencing FKs on partitioned tables the FK shares the referenced index, so the wrong constraint OID can be returned.

The other fix hunk (skip self-referencing FKs in `CloneFkReferenced`, tablecmds.c) has no counterpart in the current code. The clone loop no longer contains that check, and the surrounding code was restructured. I did not change it. The comment-only hunks were not touched.

Failing oracle case: src/test/regress||foreign_key
