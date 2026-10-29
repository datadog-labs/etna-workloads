# Rationale

## Changed hunk: `tree/src/vtab.c`, `callFinaliser()`

Reverses the fix's vtab.c hunk. The fix changed the lookup of the module
method from `x = (int (*)(sqlite3_vtab *))((char *)pVtab->pModule + offset);`
to `x = *(int (**)(sqlite3_vtab *))((char *)pVtab->pModule + offset);`.
In 3.54.1 the same line lives in `callFinaliser(db, offset)` (with `p->pModule`).
I restored the buggy form: it treats the address of the method slot inside
`sqlite3_module` as the function pointer, rather than dereferencing the slot.
The `if( x )` check is always true and calling it jumps into the module
struct data, so xCommit/xRollback crash.

The other fix hunks (update.c `pParse->pVirtualLock`, test8.c, sqlite.h.in)
were not reversed: update.c's equivalent is now `sqlite3VtabMakeWritable`, and
the others are test or header cleanups not behavioral here.

## Oracle failures

`./check.sh`: all 14 `test/vtab4.test` cases fail (testfixture crashes on the
first xCommit/xRollback call, so the run is incomplete). `test/auth.test`
cases are unaffected.
