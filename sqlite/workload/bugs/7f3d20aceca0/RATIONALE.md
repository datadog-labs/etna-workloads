# Rationale

## Change: ext/misc/unionvtab.c, unionConnect()
Fix hunk: the "Compose a CREATE TABLE statement and pass it to declare_vtab()"
code was moved out of the `if( rc==SQLITE_OK ){ ... unionSourceCheck() }` block
into its own `if( rc==SQLITE_OK )` guard, so it is skipped after an earlier error.

In 3.54.1 the code already has a separate `if( rc==SQLITE_OK )` guard for the compose block
(after the "no source tables configured" check and the source check). I removed that guard
(replaced with a bare `{ ... }`), so the block runs even when configuration failed. That
restores the pre-fix behaviour: `&pTab->aSrc[0]` is used and `unionGetDb()` dereferenced
when the configuration was erroneous (e.g. zero source rows, so aSrc is NULL).

## Oracle failures
test/unionvtab.test crashes at unionvtab-2.5 (zero source tables, expects
"no source tables configured"); all later cases (2.6.x, 2.7.1, 3.x ...) don't run.
