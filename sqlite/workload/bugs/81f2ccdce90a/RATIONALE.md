# Rationale

## Changed hunk
`tree/src/alter.c`, `sqlite3AlterFinishAddColumn()`: removed the
`sqlite3AuthCheck(pParse, SQLITE_ALTER_TABLE, zDb, pTab->zName, 0)` block
(inside `#ifndef SQLITE_OMIT_AUTHORIZATION`) that follows the
`sqlite3FindTable()` lookup.

This reverses the only implementation hunk of fix.patch (the authorization
callback added to ALTER TABLE ADD COLUMN, ticket #1479). The block is
identical to the one the fix added, so removing it restores the pre-fix
behaviour: ADD COLUMN never invokes the authorizer. No other path in
3.54.1 performs this check for ADD COLUMN (`sqlite3AlterBeginAddColumn` has
none), so nothing else needed reverting.

## Oracle failures
`./check.sh` reports 5 failures in test/auth.test:
auth-1.302, 1.304, 1.305, 1.306, 1.308.
- 1.302/1.305/1.308: `authargs` is never set, since the callback isn't called.
- 1.304: SQLITE_IGNORE is not honoured, so the column is added anyway.
- 1.306: SQLITE_DENY is not honoured, so the statement succeeds instead of
  returning "not authorized".
