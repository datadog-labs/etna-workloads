# Rationale

Fix reversed: `src/resolve.c` hunk, which added `sqlite3ViewGetColumnNames()` in
`lookupName()` when `pTab->nCol==0`. That code no longer exists in 3.54.1. The
virtual table column load now happens in `selectExpander()` (src/select.c), and
`renameResolveTrigger()` (src/alter.c) feeds trigger DELETE/UPDATE steps through
`sqlite3SelectPrep()`. This is the "other path" that covers the case.

Change: in `selectExpander()` (src/select.c), skip `sqlite3ViewGetColumnNames()` for
a virtual table while `IN_RENAME_OBJECT`. During ALTER TABLE RENAME, a trigger that
references a not-yet-connected virtual table (rtree) is then resolved with
`nCol==0`. This is the pre-fix state: no column load for such a table during name
resolution.

Oracle result: alter-17.100 fails (rtree table in a trigger body, then
ALTER TABLE RENAME) with `selectExpander: Assertion '0' failed`.
Earlier alter cases pass.
