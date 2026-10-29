# Rationale

Fix: if the SQLITE_FCNTL_PRAGMA file-control returns anything other than
SQLITE_OK or SQLITE_NOTFOUND, treat it as an error (`else if( rc!=SQLITE_NOTFOUND )`
block in `sqlite3Pragma`). The other fix hunk (BeginBenignMalloc removal) and
the test_vfs.c change are not reverted; test_vfs.c is test-only.

## Hunk changed: src/pragma.c, sqlite3Pragma()

Removed the `if( rc!=SQLITE_NOTFOUND ){ ... sqlite3ErrorMsg / nErr++ / pParse->rc = rc; goto pragma_out; }`
block that follows the `rc==SQLITE_OK` branch. This is the 3.54.1 equivalent
of the block the fix added. Without it, any non-OK/non-NOTFOUND result from the
VFS is silently ignored: the pragma falls through to the built-in pragma lookup,
no error or message is reported, and an unknown pragma is a no-op (pre-fix behaviour).

## Oracle failures

pragma-19.1 .. pragma-19.4 (`PRAGMA error`, `error='msg'`, `error='7 msg'`,
`error=7`) fail: they expect `1 {error message}` but get `0 {}`, since the
VFS error code is ignored.
