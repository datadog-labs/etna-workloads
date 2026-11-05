# Rationale

## src/backend/parser/parse_utilcmd.c, transformPartitionRangeBounds()
Traces to the single hunk of fix_impl.patch. The fix added a `cname == NULL` branch that lets the
normal expression transformation report errors when a ColumnRef is not a single-field name. I removed
that branch. The code is back to `Assert(cname != NULL); if (strcmp("minvalue", cname) == 0)`.
A range bound like `FROM (a.b) ...` or `(a.*)` is a ColumnRef without a single String field, so
cname stays NULL. That trips the Assert in cassert builds. Without asserts, strcmp(NULL) crashes the backend.

## Failing oracle cases
See the oracle output below (src/test/regress||create_table).
