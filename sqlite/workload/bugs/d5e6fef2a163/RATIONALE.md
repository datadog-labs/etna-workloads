# Rationale

Fix hunk (src/alter.c, renameResolveTrigger): the fix changed the lookup of the
trigger's table from `sqlite3FindTable(db, pNew->table, zDb)` (zDb = schema the
trigger SQL was read from) to the schema recorded in `pNew->pTabSchema`.

In 3.54.1 the function already had the fixed form. I reverted it: added back a
`const char *zDb` parameter to `renameResolveTrigger()`, restored
`pParse->pTriggerTab = sqlite3FindTable(db, pNew->table, zDb)`, and passed the
`zDb` already in scope at all four call sites (renameColumnFunc, renameTableFunc,
renameTableTest, renameQuotefixFunc). A temp trigger on main.t2 is therefore
resolved against temp.t2 when a temp table of the same name exists.

## Oracle results
`./check.sh`: altertab.test aborts at altertab-5.3 with
`Assertion '0' failed` in renameResolveTrigger, so 5.3 onward (including 12.x,
the fix's new test) fail. Cases 1.x–5.2 still pass.
