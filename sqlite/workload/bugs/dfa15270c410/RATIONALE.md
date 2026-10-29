# Rationale

In 3.54.1 the `expr.c` TK_COLUMN hunk of the fix was already absent. The lazy `COLFLAG_BUSY`/`COLFLAG_NOTAVAIL` code that the fix removed is still there. What stops the bug in 3.54.1 is the `insert.c` hunk: `sqlite3ComputeGeneratedColumns()` walks each generated column's expression and computes columns in dependency order, so nothing is computed lazily inside a branch. I reversed that hunk.

## src/insert.c
- Removed `exprColumnFlagUnion()`, the `Walker`, and the do/while loop with `pRedo`/`eProgress`. This reverses the fix's `insert.c` hunks.
- Restored the old single pass over the columns. Each `NOTAVAIL` column is coded in column order (virtual columns at the end), then `NOTAVAIL` is cleared.
- Restored the old declaration `int nv;`.
- The restored loop passes `pTab` to `sqlite3ExprCodeGeneratedColumn`, because today's signature takes it.
- Why this brings the bug back: column c0 is coded first, and its expression `('a',9)<('b',c1)` references c1. c1 is then coded lazily by the TK_COLUMN case in `expr.c`, inside the branch code of the row-value comparison, which may not run. `NOTAVAIL` is cleared on c1, so later readers such as the CHECK constraint on c2 and the stored value assume c1 is computed, and the register was never set.

The `sqliteInt.h` hunks (`Walker.eCode` widened to u16, `u.pTab`) are not reverted: the field is harmless without the walker.

## Oracle
- `gencol1-8.10`, the test the fix added, now fails with `Assertion 'memIsValid(&aMem[pOp->p1])' failed` in `sqlite3VdbeExec`. This is the uninitialised register read described above.
- The cases before it in `gencol1.test` still pass. I did not check anything after it.
