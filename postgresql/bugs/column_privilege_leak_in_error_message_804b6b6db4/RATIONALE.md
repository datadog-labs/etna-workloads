# Rationale

## src/backend/access/index/genam.c, BuildIndexValueDescription()
Traces to the genam.c hunk of fix_impl.patch, which added the permission check (table-level SELECT, then per-column SELECT on all key columns, returning NULL otherwise) before building the key description.

I removed the table-level `pg_class_aclcheck` and the per-column `pg_attribute_aclcheck` loop, and the now-unused `aclresult` and `keyno` locals. The RLS check is kept. A user with no SELECT on the indexed columns now gets the key values in unique-violation and exclusion-constraint error messages, which is the original leak.

Only the genam.c part of the fix was reverted. The other hunks in fix_impl.patch (execMain.c, copy.c and others) are untouched.

## Failing oracle cases
- src/test/regress||privileges

rowsecurity still passes.
