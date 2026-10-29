# Rationale

Fix hunk (src/fkey.c, fkActionTrigger, `action==OE_Restrict` branch): the fix replaced
`sqlite3SrcListAppend(pParse, 0, &tDb, &tFrom)` (which de-quotes the names via
sqlite3NameFromToken) with a SrcList whose zName was set directly from the already
de-quoted `zFrom`.

Reverted in tree/src/fkey.c: restored `Token tFrom/tDb` (and `iDb`) and the
`sqlite3SrcListAppend(pParse, 0, &tDb, &tFrom)` call (note the original's argument
order: pTable=&tDb, pDatabase=&tFrom, which yields zName=from, zDatabase=db).
The name taken from pFKey->pFrom->zName is already de-quoted, so it is de-quoted twice.
The 3.54.1-only `fixedSchema`/`pSchema` assignments are removed; the schema is again
resolved by database name.

Oracle: fkey1-9.1 fails (table names like `"1` get double-dequoted) with
`sqlite3Dequote: Assertion z[i] failed` (crash in the test build).
