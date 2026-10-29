# Rationale

## src/build.c, sqlite3LocateTable
Reverses the build.c hunk of the fix: the eponymous-virtual-table lookup is again
guarded by `sqlite3FindDbName(db, zDbase)<1`, so eponymous tables (generate_series,
pragma_*, etc.) only resolve for an unqualified name or `main.`, not `temp.`/`aux.`.
The current code keeps its extra conditions (NO_VTAB, init.busy) and the guard was added to them.

## src/attach.c (not changed)
The fix hunk removed an `isTabFunc` guard around `pItem->pSchema = pFix->pSchema` in
sqlite3FixSrcList. That code has been rewritten (u4.pSchema, fixedSchema, no isTabFunc),
so there is no equivalent to revert; the build.c change alone restores the bug.

## Oracle failures
tabfunc01-4.2 (`SELECT * FROM temp.generate_series(1,4)`) and tabfunc01-4.3
(`aux1.generate_series`) fail with "no such table" instead of returning 1 2 3 4.
