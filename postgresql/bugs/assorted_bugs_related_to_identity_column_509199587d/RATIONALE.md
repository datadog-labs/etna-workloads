# Rationale

Hunk: src/backend/catalog/pg_depend.c, getIdentitySequence().
Traces to the fix.patch hunk in pg_depend.c that added the partition branch
(looking up the column by name in the topmost ancestor and remapping attnum).
I removed the name-based attnum remapping, keeping only the ancestor lookup.
The ancestor's identity sequence is then looked up with the partition's attnum,
which is wrong when the partition's column order differs from the parent's
(finding no sequence or the wrong one), as before the fix.

Failing oracle case: src/test/regress||identity (expected; see oracle run)
