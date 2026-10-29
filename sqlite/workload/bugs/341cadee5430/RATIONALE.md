# Rationale

Fix hunk (src/vtab.c, sqlite3VtabSavepoint): added `pVTab->pVtab &&` guard so
savepoint methods are not called on a VTable whose sqlite3_vtab was already
destroyed (DROP TABLE inside a transaction). The second hunk (`pVTab->pVtab`
in the xMethod call) is already equivalent in 3.54.1, so it is unchanged.

Change: in tree/src/vtab.c, removed the `pVTab->pVtab &&` condition from
`if( pVTab->pVtab && pMod->iVersion>=2 )`. That is exactly the pre-fix condition;
the rest of the function (lock/unlock, defensive flag) is unrelated.

Oracle: test/fts3drop.test crashes at fts3drop-1.2 (ROLLBACK TO after DROP TABLE
calls xRollbackTo with a NULL sqlite3_vtab), so 1.2-1.5 fail; 1.1 passes.
