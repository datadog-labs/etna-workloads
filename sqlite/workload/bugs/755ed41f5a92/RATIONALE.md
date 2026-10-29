# Rationale

## Changes (src/build.c)
1. `sqlite3EndTable()`: removed `&& !IN_SPECIAL_PARSE` from the
   `(p->tabFlags & TF_Autoincrement)!=0` test that decides whether to run
   `CREATE TABLE sqlite_sequence` via `sqlite3NestedParse()`. This is the exact
   reverse of the fix hunk in `fix.patch`.
2. `sqlite3NestedParse()`: removed the later-added guard
   `if( pParse->eParseMode ) return;`. It covered the same case from another
   path (nested parse during a special parse such as the rename/drop-column
   parse of a corrupt schema), so with only hunk 1 reverted the bug did not
   reappear. Same defect: running a nested schema-modifying parse while
   in a special parse mode.

## Oracle failures
`alterdropcol-8.1` and `alterdropcol-8.2`: with a schema whose t1 is
AUTOINCREMENT but no sqlite_sequence table exists, `ALTER TABLE t1 DROP COLUMN b`
re-parses the CREATE TABLE in special parse mode, tries to create
sqlite_sequence, and fails instead of producing
`CREATE TABLE t1(a INTEGER PRIMARY KEY AUTOINCREMENT)`.
