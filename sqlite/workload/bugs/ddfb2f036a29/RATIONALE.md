# Rationale

Fix hunk reversed: the `pragma.c` hunk that added, in `sqlite3Pragma()`, a call to
`sqlite3OpenTempDatabase(pParse)` when `iDb==1` (temp db named explicitly in the pragma).
In version-3.54.1 this block is still present verbatim (src/pragma.c, after
`pDb = &db->aDb[iDb];`), so removing it restores the pre-fix behaviour: pragmas like
`PRAGMA temp.cache_size` run against an unopened temp database (`aDb[1].pBt==0`).

The build.c/sqliteInt.h hunks (making `sqlite3OpenTempDatabase` non-static and declaring it)
are only enablers; the function is still used elsewhere (build.c, backup.c, vdbeblob.c), so they stay.
The `SQLITE_OMIT_PAGER_PRAGMAS` hunk is a build-option guard, not part of the bug.

## Oracle result
test/pragma.test aborts at line 91 with "SQL logic error" on
`PRAGMA temp.default_cache_size` (before the temp db is opened), so every oracle case
(incl. pragma-12.1..12.3) is reported failing via incomplete run.
