# Rationale

Changed hunk: src/backend/parser/parse_utilcmd.c, expandTableLikeClause().
Traces to the fix.patch hunk that replaced `relation_openrv(table_like_clause->relation, NoLock)`
with an OID check plus `relation_open(table_like_clause->relationOid, NoLock)`.
I restored the by-name open. If the name resolves differently after the table was locked
(e.g. search_path change), the LIKE expansion examines a different table than
transformTableLikeClause did.

Only this hunk was changed. The relationOid field is still set but now unused.

Oracle case expected to fail: src/test/regress||create_table_like — confirmed FAIL in the oracle run
