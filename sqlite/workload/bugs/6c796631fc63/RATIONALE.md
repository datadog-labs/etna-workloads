# Rationale

## Change: ext/fts5/fts5_storage.c, sqlite3Fts5StorageContentInsert()
Reverses the single implementation hunk of the fix. The fix changed
`if( sqlite3_value_nochange(pVal) ){ assert( p->pSavedRow ); ...` into
`if( sqlite3_value_nochange(pVal) && p->pSavedRow ){`, because the assert is
reachable on a corrupt database (pSavedRow is not set). In 3.54.1 the same
condition lives in the user-defined column loop (`i=2..nCol+1`), so I restored
`if( sqlite3_value_nochange(pVal) ){` plus `assert( p->pSavedRow );` there.
The other `p->pSavedRow && sqlite3_value_nochange(pVal)` check (in the
index-building function) is not part of this fix and is unchanged.

## Failing oracle case
fts5corrupt3-81.2 (`UPDATE t1 SET b=zeroblob(299)` on the corrupt db) aborts:
`Assertion 'p->pSavedRow' failed` in sqlite3Fts5StorageContentInsert, instead of
returning "database disk image is malformed".
