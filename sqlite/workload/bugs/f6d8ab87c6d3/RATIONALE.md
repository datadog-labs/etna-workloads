# Rationale

Fix (CVS 3592) added, in OP_VerifyCookie's schema-mismatch branch,
`sqlite3ResetInternalSchema(db, p1)` and `sqlite3ExpirePreparedStatements(db)`
before returning SQLITE_SCHEMA. Without them the stale in-memory schema was kept,
so the sqlite3_prepare_v2 re-prepare used the old schema and kept hitting SQLITE_SCHEMA.

In 3.54.1 the equivalent is the schema-mismatch branch of OP_Transaction (src/vdbe.c).
I removed the modern counterparts of the two added calls:
- `sqlite3ResetOneSchema(db, pOp->p1)` (with its cookie-mismatch guard), the analogue of ResetInternalSchema;
- `p->expired = 1`, the analogue of expiring prepared statements.
`rc = SQLITE_SCHEMA` is kept.

Oracle failures: capi3c-20.1 to 20.4 (the test the fix added: another connection
creates a table, then sqlite3_step on a prepared_v2 statement returns SQLITE_SCHEMA
instead of SQLITE_ROW), plus capi3c-19.4.2, 21.6-21.8, 23.x and 24.x (the later
tests fail with "no such table: t5" after the reprepare used a stale schema).
