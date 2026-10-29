# Rationale

Fix hunk (src/vdbe.c, OP_SetCookie): after updating the cookie, `if( pOp->p1==1 )` calls
`sqlite3ExpirePreparedStatements(db)` so any change to the TEMP schema expires all prepared statements.

In 3.54.1 the same block lives in OP_SetCookie in `tree/src/vdbe.c` (now
`sqlite3ExpirePreparedStatements(db, 0); p->expired = 0;`). I removed that whole block, restoring
the pre-fix behaviour: TEMP schema changes no longer expire cached statements. No other code was changed.

## Oracle failures (test/tkt1644.test)
- tkt1644-1.2: cached `SELECT * FROM v1` still reads t1 (got 1, expected 99) after the TEMP view is redefined.
- tkt1644-1.4: cached `SELECT * FROM t1` still reads main t1 after TEMP table t1 is created (got 1, expected empty).
- tkt1644-2.2: expected SQLITE_ERROR/SQLITE_SCHEMA, got SQLITE_DONE/SQLITE_OK (statement not expired).
