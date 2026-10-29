# Rationale

Both hunks of the fix's `src/where.c` change were reversed in `whereLoopAddBtreeIndex()` (`tree/src/where.c`). The code is the same as before the fix, and the hunks still applied cleanly in position.

1. Removed the assert `nEq<nKeyCol || idxType!=SQLITE_IDXTYPE_PRIMARYKEY`. This reverses hunk 1.
2. Removed the extra condition `(nEq<nKeyCol || idxType!=PRIMARYKEY)` from the recursive `whereLoopAddBtreeIndex()` call. This reverses hunk 2. Without it, the planner treats the non-key content columns of a WITHOUT ROWID primary-key index as ordered, searchable key columns, so it can add an equality constraint on a column past nKeyCol.

## Oracle failure
`without_rowid1-14.1` (`SELECT * FROM t1 WHERE a=20 OR (a=10 AND b=10)` after `ALTER TABLE ADD COLUMN b`) aborts with `Assertion vdbeRecordCompareDebug(...) failed` in `sqlite3VdbeRecordCompareWithSkip`. The test run stops there, so 14.2 and later cases were not run.
