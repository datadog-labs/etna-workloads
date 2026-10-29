# Rationale

The fix replaced the body of `sqlite3VtabWriteAll()` (src/where.c), which set
`cookieMask = writeMask = all schemas` on the top-level Parse, with a loop
calling `sqlite3BeginWriteOperation(pParse, 0, i)` for each schema.

In 3.54.1 that function is now `sqlite3VtabUsesAllSchemas()`. It calls
`sqlite3CodeVerifySchema()` on every schema and calls
`sqlite3BeginWriteOperation()` on every schema only when the statement is
already a write (`writeMask` nonzero). I reverted its body to the pre-fix
form: set `cookieMask` and `writeMask` on `sqlite3ParseToplevel(pParse)` to
cover all `nDb` schemas, unconditionally. This is the code the fix removed.

## Oracle failures
`dbpage-300` (`SELECT * FROM sqlite_temp_schema, sqlite_dbpage;`, added by the
fix) hits `Assertion 'pX!=0' failed` in `sqlite3VdbeExec` and aborts the run.
That also makes dbpage-400 through dbpage-820 fail, since the run is incomplete.
