# Rationale

## src/build.c, sqlite3TableColumnToStorage()
Reverses the build.c hunk of the fix: removes `|| iCol<0` from the early return,
so a negative iCol (the rowid, -1) is no longer passed through unchanged. With a
virtual column in the table, -1 is mapped through the storage loop and yields a
wrong register (0 or a virtual-column slot) instead of -1.

The expr.c hunk of the fix (guarding iCol>=0 in the TK_REGISTER/trigger-column
caller) is already absent in 3.54.1: the caller at expr.c ~5710 calls
sqlite3TableColumnToStorage(pTab, iCol) directly, relying on the build.c guard. So only
build.c needs reverting; this re-creates the pre-fix behaviour for rowid references.

## Oracle failures
test/gencol1.test gencol1-11.20 (INSERT OR REPLACE with FK on table with generated column
and rowid alias) aborts with `Assertion memIsValid(&aMem[pOp->p1]) failed` in
sqlite3VdbeExec (expected: "FOREIGN KEY constraint failed"). Later cases don't run.
