# Rationale

Fix (2007): in sqlite3_step(), for prepare_v2 statements, call
`sqlite3Error(p->db, p->rc, 0)` so the db error code equals the value returned.

In 3.54.1 this is done in `sqlite3Step()` (src/vdbeapi.c) in two places:
`sqlite3VdbeTransferError(p)` for SAVESQL statements on error, and the
unconditional `db->errCode = rc;` after it.

Changes (src/vdbeapi.c, sqlite3Step):
1. `rc = sqlite3VdbeTransferError(p);` -> `rc = p->rc;` (error path only returns the
   code; no longer copies it to the db handle).
2. `db->errCode = rc;` -> only for non-SAVESQL statements, so prepare_v2 statements
   no longer get db errCode set to the step return value.

Together this restores the pre-fix state: sqlite3_step() on a prepare_v2 statement
returns p->rc without setting the database error code.

Oracle: capi3c-21.2 fails (sqlite3_errcode after an interrupted step does not
return SQLITE_INTERRUPT). 1 of 291 tests fail.
