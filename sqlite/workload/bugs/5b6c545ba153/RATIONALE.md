# Rationale

Fix (ticket b72787b1): in the schema-cookie check, replace `sqlite3ExpirePreparedStatements(db)` with `p->expired = 1`, so only the statement that saw the stale cookie expires.

In 3.54.1 the check lives in `OP_Transaction` (src/vdbe.c, the `iMeta!=pOp->p3` / schema-cookie branch), not `OP_VerifyCookie`. It already had `p->expired = 1`. I changed that line back to `sqlite3ExpirePreparedStatements(db, 0)`, which expires every statement on the connection, including the one currently running. The second argument is 0 (expire immediately), matching the old behaviour. The `rc = SQLITE_SCHEMA` and `changeCntOn = 0` lines are unchanged.

## Oracle
- `tkt-b72787b1.1` fails with "abort due to ROLLBACK". Statement B (the UNION ALL) is expired while running, and it aborts when the second SELECT is reached.
- The `progress-*` cases still pass. They are in the oracle only because the fix patch touched that file's mode.
