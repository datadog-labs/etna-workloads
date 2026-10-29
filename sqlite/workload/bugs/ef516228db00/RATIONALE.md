# Rationale

Fix: `sqlite3Step()` had `ALWAYS(p->rc==SQLITE_OK)` guarding `p->rc = SQLITE_SCHEMA`
for an expired statement. The fix widened it to also allow `p->rc==SQLITE_SCHEMA`,
since a second sqlite3_step() after an SQLITE_SCHEMA return sees rc==SQLITE_SCHEMA.

Change (src/vdbeapi.c, sqlite3Step, `VDBE_READY_STATE` + `p->expired` branch): the
unconditional `p->rc = SQLITE_SCHEMA;` is re-wrapped in `if( ALWAYS(p->rc==SQLITE_OK) )`,
the pre-fix condition. The assignment is otherwise the same, so release behaviour is
unchanged; in SQLITE_DEBUG builds ALWAYS() asserts.

Oracle: schema-13.2 (second step after SQLITE_SCHEMA) hits
`Assertion '0' failed` in sqlite3Step and aborts the testfixture; 13.3 and later never run.
