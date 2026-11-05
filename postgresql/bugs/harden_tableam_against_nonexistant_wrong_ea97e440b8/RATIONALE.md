# Rationale

Changed: src/backend/commands/tablecmds.c, DefineRelation (explicit `stmt->accessMethod` branch).
Traces to the fix.patch tablecmds.c hunk, which replaced an open-coded AMNAME syscache lookup with
`get_table_am_oid(accessMethod, false)`. I restored the open-coded lookup. It checks only that a
pg_am row exists, not that its amtype is TABLE. So `CREATE TABLE ... USING btree` (an index AM)
is accepted instead of raising an error.

Failing oracle cases (expected): src/test/regress||create_am
