# Rationale

## Hunk changed
`tree/src/build.c`, `sqlite3AddCollateType()`: the guard now reads
`if( (p = pParse->pNewTable)==0 || IN_RENAME_OBJECT || IN_DECLARE_VTAB ) return;`

This reverses the fix's only implementation hunk, which removed `|| IN_DECLARE_VTAB`
from the same guard. In 3.54.1 the macro is still `IN_DECLARE_VTAB` and the guard
also has `IN_RENAME_OBJECT`, which is unrelated and kept. With the check back,
COLLATE clauses in the CREATE TABLE passed to sqlite3_declare_vtab() are ignored,
so virtual table columns lose their default collation.

## Oracle failure
`vtab5.2.2` fails. `SELECT str FROM echo_strings ORDER BY 1` returns
`ABc2 Abc3 aBc4 abc1` (BINARY order) instead of `abc1 ABc2 Abc3 aBc4` (NOCASE).
The other cases pass.
