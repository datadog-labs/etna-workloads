# Rationale

## Change: tree/src/update.c (sqlite3Update, ephemeral-table path for WITHOUT ROWID / non-rowid update)

Fix hunk reversed: `OP_Null, 0, iPk, iPk+nPk-1` -> `OP_Null, 0, iPk`.
In 3.54.1 the line is `if( pPk ) sqlite3VdbeAddOp3(v, OP_Null, 0, iPk, iPk+nPk-1);`
(now guarded by `pPk`). I restored the pre-fix form, which nulls only the first
PK register, so the remaining nPk-1 key registers are left uninitialized and are
later read by OP_MakeRecord / OP_Found.

## Oracle failure
without_rowid1-9.0 (CREATE TABLE t2(b,c,PRIMARY KEY(b,c)) WITHOUT ROWID; unique index on b;
UPDATE ... WHERE b='') aborts with
`Assertion 'memIsValid(&r.aMem[ii])' failed` in sqlite3VdbeExec, the uninitialized-register
assert the fix describes. Later cases in the file (10.x) are not reached.
