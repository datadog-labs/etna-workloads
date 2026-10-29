# Rationale

## Change: tree/src/vdbeapi.c, sqlite3Step() error path (end of step)
Reverses the fix hunk in `sqlite3_step()` that replaced
`rc = db->errCode = p->rc;` with `rc = sqlite3VdbeTransferError(p);`.
In 3.54.1 the same branch (statement prepared with SQLITE_PREPARE_SAVESQL,
i.e. prepare_v2/v3, and rc!=DONE) again copies only the error code to the
database handle, so the error message stays in the Vdbe until
sqlite3_reset()/finalize(). `sqlite3VdbeTransferError()` itself (the fix's new
function, still used by sqlite3VdbeReset) is left intact. The other call in the
SQLITE_SCHEMA/expired branch was not changed (no message involved there).

## Oracle failures (test/errmsg.test)
- errmsg-1.2: after sqlite3_step with prepare_v2, errmsg gives
  "SQL logic error" instead of "custom message".
- errmsg-2.3: errmsg gives "constraint failed" instead of
  "UNIQUE constraint failed: t1.b".
