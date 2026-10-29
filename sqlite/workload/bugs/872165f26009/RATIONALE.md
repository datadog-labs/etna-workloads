# Rationale

All changes are in `tree/src/alter.c`, `sqlite3AlterRenameColumn()`.

1. Fix hunk: added `if( SQLITE_OK!=isSystemTable(...) ) goto exit_rename_column;`.
   In 3.54.1 the equivalent is `isAlterableTable()` (the "table %s may not be altered" check).
   I removed that call, so columns of system tables (e.g. sqlite_stat1) can be renamed again.
   `isRealTable()` (view/virtual table check) is left alone.

2. Fix hunk: the nested UPDATE's WHERE gained `name NOT LIKE 'sqlite_%'`, so the system
   tables' schema rows are excluded from the rewrite. In 3.54.1 that is
   `name NOT LIKE 'sqliteX_%' ESCAPE 'X' AND (type != 'index' OR tbl_name = %Q)`.
   I removed the NOT LIKE filter and kept `type != 'index' OR tbl_name = %Q`. The rename
   function is then run on sqlite_stat1 and other sqlite_* rows, as it was before the fix.

The fix's third hunk (`if( pParse->pVdbe )` guard) is not reverted. 3.54.1 handles that in `renameReloadSchema`.

## Oracle failures
check.sh reports 5 failures: altercol-5.1, altercol-6.1 (twice), altercol-6.2, altercol-12.1.2.
altercol-5.1 is the rename after ANALYZE, and 6.1 is the rename of a sqlite_stat1 column
that should be refused with "table sqlite_stat1 may not be altered".
